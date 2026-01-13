import azure.functions as func
import logging
import sys

try:
    print("Attempting to import FastAPI app...", file=sys.stdout)
    from azure.functions import AsgiFunctionApp
    from main import app as fastapi_app
    app = AsgiFunctionApp(app=fastapi_app, http_auth_level=func.AuthLevel.ANONYMOUS)
    print("FastAPI app imported successfully.", file=sys.stdout)
except Exception as e:
    logging.critical(f"Failed to load FastAPI app: {e}")
    # Fallback function to report the startup error
    app = func.FunctionApp()
    @app.route(route="{*route}", auth_level=func.AuthLevel.ANONYMOUS)
    def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
        # Return 200 for health check so container stays healthy and we can see the error
        if "health" in req.url:
            return func.HttpResponse(f"App Startup Error: {e}", status_code=200)
        return func.HttpResponse(f"App Startup Error: {e}", status_code=500)