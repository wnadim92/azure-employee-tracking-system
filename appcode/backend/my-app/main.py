import os
import uuid
import logging
import time
from typing import List, Optional

from fastapi import FastAPI, HTTPException, APIRouter
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

app = FastAPI()
router = APIRouter()

@app.get("/")
def root():
    return {"message": "FastAPI on Azure Functions is running!"}

@router.get("/health")
def health_check():
    return {"status": "ok", "environment": "Azure Functions"}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variable to hold the container client
_container = None

def get_container():
    global _container
    if _container:
        return _container

    from azure.cosmos import CosmosClient, PartitionKey
    from azure.identity import DefaultAzureCredential

    # These are set by Terraform in Azure or docker-compose locally
    endpoint = os.getenv("COSMOS_DB_ENDPOINT")
    db_name = os.getenv("DB_DATABASE_NAME", "EmployeeDB")
    
    key = os.getenv("COSMOS_DB_KEY")
    
    if key:
        # Only disable SSL verification if connecting to the local emulator
        is_emulator = "localhost" in endpoint or "127.0.0.1" in endpoint or "cosmosdb" in endpoint
        logging.info(f"Connecting to Cosmos DB with key. SSL Verify: {not is_emulator}")
        
        client = CosmosClient(endpoint, credential=key, connection_verify=not is_emulator)
    else:
        logging.info("Connecting to Cosmos DB with Managed Identity.")
        credential = DefaultAzureCredential()
        client = CosmosClient(endpoint, credential=credential)
    
    # Retry logic to handle Cosmos DB Emulator startup delay
    last_error = None
    for i in range(40):
        try:
            # Provision Database and Container if they don't exist
            database = client.create_database_if_not_exists(id=db_name)
            _container = database.create_container_if_not_exists(
                id="employees", 
                partition_key=PartitionKey(path="/id")
            )
            logging.info("Cosmos DB Client initialized")
            return _container
        except Exception as e:
            last_error = e
            logging.warning(f"Attempt {i+1}/40: Failed to connect to Cosmos DB: {e}")
            time.sleep(3)
            
    raise Exception(f"Could not connect to Cosmos DB after multiple attempts. Last error: {last_error}")

class Employee(BaseModel):
    id: Optional[str] = None
    name: str
    address: Optional[str] = None
    dob: Optional[str] = None
    role: Optional[str] = None
    hire_date: Optional[str] = Field(None, alias="hireDate")
    manager: Optional[str] = None

    class Config:
        populate_by_name = True

@router.get("/employees", response_model=List[Employee])
def get_employees():
    container = get_container()
    employees = []
    # Filter out the counter document
    items = container.query_items(query="SELECT * FROM c WHERE c.id != 'employee_id_counter'", enable_cross_partition_query=True)
    for item in items:
        employees.append(Employee(**item))
    return employees

@router.post("/employee")
def save_employee(emp: Employee) -> Employee:
    container = get_container()

    if emp.id is None:
        from azure.core.exceptions import ResourceNotFoundError
        # Simple auto-increment logic using a counter document
        counter_id = "employee_id_counter"
        try:
            counter_doc = container.read_item(item=counter_id, partition_key=counter_id)
        except ResourceNotFoundError:
            counter_doc = {"id": counter_id, "last_id": 0}
        
        new_id = int(counter_doc.get("last_id", 0)) + 1
        counter_doc["last_id"] = new_id
        container.upsert_item(counter_doc)
        emp.id = str(new_id)

    # upsert_item handles both Create and Update
    created_item = container.upsert_item(emp.model_dump(by_alias=True))
    return Employee(**created_item)

@router.get("/employees/{employee_id}", response_model=Employee)
def get_employee_by_id(employee_id: str):
    container = get_container()
    from azure.core.exceptions import ResourceNotFoundError
    try:
        # Use read_item for efficient point reads.
        # This assumes the container's partition key is '/id'.
        item = container.read_item(item=employee_id, partition_key=employee_id)
        return Employee(**item)
    except ResourceNotFoundError:
        raise HTTPException(status_code=404, detail="Employee not found")

@router.delete("/employees/{employee_id}", status_code=204)
def delete_employee(employee_id: str):
    container = get_container()
    from azure.cosmos.exceptions import CosmosHttpResponseError
    try:
        # To delete, need the item's id and its partition key.
        # This assumes the container's partition key is '/id'.
        container.delete_item(item=employee_id, partition_key=employee_id)
    except CosmosHttpResponseError as e:
        if e.status_code == 404:
            # Item not found is acceptable for a delete operation (idempotency)
            pass
        else:
            raise

# Mount routes at root (for Azure Functions which adds /api prefix)
app.include_router(router)
# Mount routes at /api (for Local Docker Compose which has no prefix)
app.include_router(router, prefix="/api")
