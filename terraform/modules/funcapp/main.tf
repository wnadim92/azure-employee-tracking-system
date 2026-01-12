# 2. The Linux Function App
resource "azurerm_linux_function_app" "this" {
  name                = var.funcapp_name
  resource_group_name = var.rg_name
  location            = var.region

  service_plan_id       = var.service_plan_id
  storage_account_name  = module.storage.storage_account_name
  
  # Identity-Based Host Storage (Secret-less)
  storage_uses_managed_identity = true

  # VNet Integration (Allowing Function to talk to Cosmos/Storage via Private Endpoints)
  virtual_network_subnet_id = var.vnet_integration_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_resource_id]
  }

  app_settings = {
    # --- Host Storage Connection ---
    "AzureWebJobsStorage__accountName" = module.storage.storage_account_name
    "AzureWebJobsStorage__credential"  = "managedidentity"
    "AzureWebJobsStorage__clientId"    = var.uami_client_id # MUST be Client ID

    # --- Cosmos DB Connection ---
    "CosmosDbConnection__accountEndpoint" = var.cosmosdb_endpoint
    "CosmosDbConnection__credential"      = "managedidentity"
    "CosmosDbConnection__clientId"        = var.uami_client_id
    
    # Force Azure SDK to use this identity
    "AZURE_CLIENT_ID" = var.uami_client_id

    # Necessary for VNet Integration to route through Private DNS
    "WEBSITE_CONTENTOVERVNET"      = "1"
    "WEBSITE_VNET_ROUTE_ALL"       = "1"
  }

  site_config {
    vnet_route_all_enabled = true
    application_stack {
      python_version = "3.11"
    }
  }
}

# 3. Private Endpoint for the Function App itself (Inbound access)
module "pe" {
  source                         = "../pe"
  resource_name                  = "${var.funcapp_name}-sites"
  rg_name                        = var.rg_name
  region                         = var.region
  subnet_id                      = var.pe_subnet_id
  private_connection_resource_id = azurerm_linux_function_app.this.id
  pe_subresource_type            = ["sites"]
  private_dns_zone_id            = var.sites_dns_zone_id
}

# 1. The Storage Module (Infrastructure for the Function)
module "storage" {
  source               = "../storage"
  strg_name            = var.funcapp_name
  rg_name              = var.rg_name
  region               = var.region
  subnet_id            = var.pe_subnet_id
  backend_principal_id = var.uami_principal_id
  blob_dns_zone_id     = var.blob_dns_zone_id
  file_dns_zone_id     = var.file_dns_zone_id
  table_dns_zone_id    = var.table_dns_zone_id
  queue_dns_zone_id    = var.queue_dns_zone_id
}