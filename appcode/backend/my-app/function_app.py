import azure.functions as func
from main import app # Import the FastAPI app from main.py

function_app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@function_app.route(route="{*route}")
def fastapi_app_handler(req: func.HttpRequest) -> func.HttpResponse:
    """
    Wraps the FastAPI app with Azure Functions to handle all HTTP requests.
    """
    return func.AsgiMiddleware(app).handle(req)