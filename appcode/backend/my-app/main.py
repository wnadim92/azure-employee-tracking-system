import os
import uuid
import logging
from typing import List, Optional
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# 2026 Azure SDKs
from azure.cosmos.aio import CosmosClient
from azure.identity.aio import DefaultAzureCredential

@asynccontextmanager
async def lifespan(app: FastAPI):
    # These are set by your Terraform in Azure
    endpoint = os.getenv("COSMOS_ENDPOINT")
    db_name = os.getenv("DB_DATABASE_NAME", "EmployeeDB")
    
    # Authenticate via Managed Identity (Zero Keys)
    credential = DefaultAzureCredential()
    client = CosmosClient(endpoint, credential=credential)
    
    # Store the container client in app state
    app.state.container = client.get_database_client(db_name).get_container_client("employees")
    logging.info("Cosmos DB Client initialized")
    
    yield
    
    await client.close()
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
async def save_employee(emp: Employee):
    # upsert_item handles both Create and Update
    await app.state.container.upsert_item(emp.model_dump(by_alias=True))
    return {"success": True}
