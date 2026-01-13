import azure.functions as func
import logging

try:
    from azure.functions import AsgiFunctionApp
    from main import app as fastapi_app
    app = AsgiFunctionApp(app=fastapi_app, http_auth_level=func.AuthLevel.ANONYMOUS)
except Exception as e:
    logging.critical(f"Failed to load FastAPI app: {e}")
    # Fallback function to report the startup error
    app = func.FunctionApp()
    @app.route(route="{*route}", auth_level=func.AuthLevel.ANONYMOUS)
    def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
        return func.HttpResponse(f"App Startup Error: {e}", status_code=500)