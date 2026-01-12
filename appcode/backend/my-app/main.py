import os
import uuid
import logging
from typing import List, Optional
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# 2026 Azure SDKs
from azure.cosmos.aio import CosmosClient
from azure.cosmos.exceptions import CosmosHttpResponseError
from azure.identity.aio import DefaultAzureCredential
from azure.core.exceptions import ResourceNotFoundError

@asynccontextmanager
async def lifespan(app: FastAPI):
    # These are set by your Terraform in Azure or docker-compose locally
    endpoint = os.getenv("COSMOS_DB_ENDPOINT")
    db_name = os.getenv("DB_DATABASE_NAME", "EmployeeDB")
    
    # For local development, use the master key. For production, use DefaultAzureCredential.
    key = os.getenv("COSMOS_DB_KEY")
    credential = None
    
    if key:
        logging.info("Connecting to Cosmos DB Emulator with key.")
        client = CosmosClient(endpoint, credential=key)
    else:
        logging.info("Connecting to Cosmos DB with Managed Identity.")
        credential = DefaultAzureCredential()
        client = CosmosClient(endpoint, credential=credential)
    
    # Store the container client in app state
    app.state.container = client.get_database_client(db_name).get_container_client("employees")
    logging.info("Cosmos DB Client initialized")
    
    yield
    
    await client.close()
    if credential:
        await credential.close()

app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class Employee(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    address: Optional[str] = None
    dob: Optional[str] = None
    role: Optional[str] = None
    hire_date: Optional[str] = Field(None, alias="hireDate")
    manager: Optional[str] = None

    class Config:
        populate_by_name = True

@app.get("/api/employees", response_model=List[Employee])
async def get_employees():
    employees = []
    items = app.state.container.query_items(query="SELECT * FROM c", enable_cross_partition_query=True)
    async for item in items:
        employees.append(Employee(**item))
    return employees

@app.post("/api/employee")
async def save_employee(emp: Employee) -> Employee:
    # upsert_item handles both Create and Update
    created_item = await app.state.container.upsert_item(emp.model_dump(by_alias=True))
    return Employee(**created_item)

@app.get("/api/employees/{employee_id}", response_model=Employee)
async def get_employee_by_id(employee_id: str):
    try:
        # Use read_item for efficient point reads.
        # This assumes the container's partition key is '/id'.
        item = await app.state.container.read_item(item=employee_id, partition_key=employee_id)
        return Employee(**item)
    except ResourceNotFoundError:
        raise HTTPException(status_code=404, detail="Employee not found")

@app.delete("/api/employees/{employee_id}", status_code=204)
async def delete_employee(employee_id: str):
    try:
        # To delete, you need the item's id and its partition key.
        # This assumes the container's partition key is '/id'.
        await app.state.container.delete_item(item=employee_id, partition_key=employee_id)
    except CosmosHttpResponseError as e:
        if e.status_code == 404:
            # Item not found is acceptable for a delete operation (idempotency)
            pass
        else:
            raise
