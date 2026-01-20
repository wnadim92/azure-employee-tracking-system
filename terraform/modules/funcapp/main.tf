
resource "azurerm_service_plan" "this" {
  name                = "${var.funcapp_name}-plan"
  resource_group_name = var.rg_name
  location            = var.region
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "this" {
  name                          = var.funcapp_name
  resource_group_name           = var.rg_name
  location                      = var.region
  service_plan_id               = azurerm_service_plan.this.id
  storage_account_name          = azurerm_storage_account.this.name
  storage_account_access_key    = azurerm_storage_account.this.primary_access_key
  virtual_network_subnet_id     = var.vnet_integration_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_resource_id]
  }

  app_settings = {
    "AzureWebJobsStorage"                                = azurerm_storage_account.this.primary_connection_string
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING"           = azurerm_storage_account.this.primary_connection_string
    "WEBSITE_CONTENTSHARE"                               = azurerm_storage_share.this.name
//    "WEBSITE_DNS_SERVER"                                 = "168.63.129.16" # Required for Azure DNS so can reach azure DNS such as for private endpoint DNS Zones
    "WEBSITE_SKIP_CONTENT_SHARE_VALIDATION"              = "1"
    "AzureFunctionsJobHost__Logging__Console__IsEnabled" = "true"
    "FUNCTIONS_WORKER_RUNTIME"                           = "python"
    #"WEBSITE_CONTENTOVERVNET"                            = "1"
    "FUNCTIONS_EXTENSION_VERSION"                        = "~4"
    "COSMOS_DB_ENDPOINT"                                 = var.cosmosdb_endpoint
    "COSMOS_DB_KEY"                                      = var.cosmosdb_key
    "COSMOS_DB_NAME"                                     = var.database_name
    "COSMOS_DB_URL"                                      = var.cosmosdb_endpoint
    "DB_DATABASE_NAME"                                   = var.database_name
    "WEBSITE_RUN_FROM_PACKAGE"                           = "0"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"                     = "true"
    "ENABLE_ORYX_BUILD"                                  = "true"
    "AzureWebJobsFeatureFlags"                           = "EnableWorkerIndexing"
    "PYTHONPATH"                                         = "/home/site/wwwroot/.python_packages/lib/site-packages"
    "AzureWebJobsScriptRoot"                            = "/home/site/wwwroot"
    "AzureFunctionsJobHost__CORS__AllowedOrigins"     = "*"
    # "AzureFunctionsJobHost__CORS__SupportCredentials" = "true"

  }

  site_config {
    # vnet_route_all_enabled            = true
    always_on                         = true

    # cors {
    #   allowed_origins     = var.allowed_origins
    #   support_credentials = true
    # }

    application_stack {
      python_version = "3.11"
    }
  }
}

resource "azurerm_storage_share" "this" {
  name                 = lower(var.funcapp_name)
  storage_account_name = azurerm_storage_account.this.name
  quota                = 50
}

resource "azurerm_storage_account" "this" {
  name                     = lower(substr(replace(var.funcapp_name, "-", ""), 0, 24))
  resource_group_name      = var.rg_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # SECURITY: Deny all public access
  public_network_access_enabled = var.public_network_access_enabled
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_role_assignment" "storage_access" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.uami_principal_id

  # Recommended for new identities to prevent replication lag errors
  skip_service_principal_aad_check = true
}
