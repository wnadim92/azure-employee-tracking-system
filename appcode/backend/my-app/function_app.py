import azure.functions as func
# This imports the 'app' variable from my_app/main.py
from main import app as fastapi_app

# The bridge between Azure Functions and FastAPI
app = func.AsgiFunctionApp(
    app=fastapi_app, 
    http_auth_level=func.AuthLevel.ANONYMOUS
)
