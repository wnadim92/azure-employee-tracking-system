import os
import uuid
import logging
import time
from typing import List, Optional

import azure.functions as func
from azure.functions import AsgiFunctionApp
from main import app as fastapi_app

app = AsgiFunctionApp(app=fastapi_app, http_auth_level=func.AuthLevel.ANONYMOUS)