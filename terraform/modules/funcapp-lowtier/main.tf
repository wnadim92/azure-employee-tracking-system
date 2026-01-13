
resource "azurerm_service_plan" "this" {
  name                = "${var.funcapp_name}-plan"
  resource_group_name = var.rg_name
  location            = var.region
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "this" {
  name                = var.funcapp_name
  resource_group_name = var.rg_name
  location            = var.region

  service_plan_id      = azurerm_service_plan.this.id
  storage_account_name = module.storage.storage_account_name

  storage_uses_managed_identity = false
  virtual_network_subnet_id     = var.vnet_integration_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_resource_id]
  }

  app_settings = {
    "AzureWebJobsStorage"                                = module.storage.primary_connection_string
    "WEBSITE_DNS_SERVER"                       = "168.63.129.16"
    "DOCKER_REGISTRY_SERVER_URL"               = "https://index.docker.io"
    "WEBSITE_SKIP_CONTENT_SHARE_VALIDATION"    = "1"
    "AzureFunctionsJobHost__Logging__Console__IsEnabled" = "true"
    "FUNCTIONS_WORKER_RUNTIME"                           = "python"
    "WEBSITE_CONTENTOVERVNET"                            = "1"

    "CosmosDbConnection__accountEndpoint" = var.cosmosdb_endpoint
    "CosmosDbConnection__credential"      = "managedidentity"
    "CosmosDbConnection__clientId"        = var.uami_client_id
    "COSMOS_DB_ENDPOINT"                  = var.cosmosdb_endpoint
    "DB_DATABASE_NAME"                    = var.database_name

    "AZURE_CLIENT_ID" = var.uami_client_id
    # WEBSITE_VNET_ROUTE_ALL is now handled in site_config
  }

  site_config {
    vnet_route_all_enabled = true
    always_on              = true
    health_check_path      = "/api/health"
    health_check_eviction_time_in_min = 2

    cors {
      allowed_origins     = var.allowed_origins
      support_credentials = true
    }

    application_stack {
      docker {
        registry_url = var.docker_registry_url
        image_name   = var.image_name
        image_tag    = var.image_tag
      }
    }
  }
}

# 1. The Storage Module (Infrastructure for the Function)
module "storage" {
  source            = "../storage"
  strg_name         = lower(substr(replace(var.funcapp_name, "-", ""), 0, 24))
  rg_name           = var.rg_name
  region            = var.region
  subnet_id         = var.pe_subnet_id
  principal_id      = var.uami_principal_id
  blob_dns_zone_id  = var.blob_dns_zone_id
  file_dns_zone_id  = var.file_dns_zone_id
  table_dns_zone_id = var.table_dns_zone_id
  queue_dns_zone_id = var.queue_dns_zone_id
}