import os
import asyncpg
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI()

# Enable CORS for your React App
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production, replace with your React App URL
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database Connection Pool
async def get_db_pool():
    # Format: postgres://user:pass@host:5432/dbname
    database_url = os.getenv("DATABASE_URL")
    
    # Check if we are running locally via an environment variable
    # In local.settings.json, set DB_SSL_MODE to "disable"
    ssl_mode = os.getenv("DB_SSL_MODE", "require")
    
    # Use 'require' for Azure Cosmos, but None/False for local Docker
    ssl_config = "require" if ssl_mode == "require" else None
    
    return await asyncpg.create_pool(database_url, ssl=ssl_config)

class Employee(BaseModel):
    id: Optional[int] = None
    name: str
    address: Optional[str]
    dob: Optional[str]
    role: Optional[str]
    hireDate: Optional[str]
    manager: Optional[str]

@app.get("/api/employees", response_model=List[Employee])
async def get_employees():
    pool = await get_db_pool()
    async with pool.acquire() as conn:
        rows = await conn.fetch("SELECT * FROM employees ORDER BY id ASC")
        return [
            Employee(
                id=r['id'], name=r['name'], address=r['address'],
                dob=str(r['dob']), role=r['role'], 
                hireDate=str(r['hire_date']), manager=r['manager']
            ) for r in rows
        ]

@app.post("/api/employee")
async def save_employee(emp: Employee):
    pool = await get_db_pool()
    async with pool.acquire() as conn:
        if emp.id:
            await conn.execute(
                "UPDATE employees SET name=$1, address=$2, dob=$3, role=$4, hire_date=$5, manager=$6 WHERE id=$7",
                emp.name, emp.address, emp.dob, emp.role, emp.hireDate, emp.manager, emp.id
            )
        else:
            await conn.execute(
                "INSERT INTO employees (name, address, dob, role, hire_date, manager) VALUES ($1, $2, $3, $4, $5, $6)",
                emp.name, emp.address, emp.dob, emp.role, emp.hireDate, emp.manager
            )
    return {"success": True}
