
# FastAPI Backend Service Function App
module "emp_track_middle_funcapp" {
  source                        = "../../modules/funcapp"
  funcapp_name                  = "${var.project_name}-${var.environment}-${var.region}-funcapp"
  //pe_subnet_id                  = module.emp_track_middletier_pe_snet.subnet_id
  vnet_integration_subnet_id    = module.emp_track_middletier_vnetintegration_snet.subnet_id
  uami_resource_id              = module.emp_track_managed_identity.uami_id
  uami_client_id                = module.emp_track_managed_identity.client_id
  uami_principal_id             = module.emp_track_managed_identity.principal_id
  rg_name                       = module.rg.rg_name
  region                        = var.region
  cosmosdb_endpoint             = module.emp_track_db.cosmosdb_endpoint
  allowed_origins               = ["https://${var.project_name}-${var.environment}-${var.region}-appsvc.azurewebsites.net"]
  public_network_access_enabled = true
  # blob_dns_zone_id              = azurerm_private_dns_zone.blob.id
  # file_dns_zone_id              = azurerm_private_dns_zone.file.id
  # table_dns_zone_id             = azurerm_private_dns_zone.table.id
  # queue_dns_zone_id             = azurerm_private_dns_zone.queue.id
  # sites_dns_zone_id             = azurerm_private_dns_zone.web.id
  cosmosdb_key                  = module.emp_track_db.cosmosdb_primary_key
  database_name                 = module.emp_track_db.cosmosdb_database_name
}

# contians private endpoint for middle tier Python FastAPI Backend Service Function App
# App storage account private endpoints attached, blob, table, queue, files
module "emp_track_middletier_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_middletier_pe_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-mid-pe-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region
}

# VNET Integrating Python FastAPI Backend Service Function App for internal communication to database
module "emp_track_middletier_vnetintegration_snet" {
  source             = "../../modules/subnet"
  subnet_type        = "private"
  cidr               = var.emp_track_middletier_vnetintegration_snet_cidr
  subnet_name        = "${var.project_name}-${var.environment}-${var.region}-mid-vnetinteg-snet"
  rg_name            = module.rg.rg_name
  vnet_name          = module.vnet.vnet_name
  region             = var.region
  delegation_service = "Microsoft.Web/serverFarms"
}

# cosmos db
module "emp_track_db" {
  source              = "../../modules/cosmosdb"
  db_name             = "${var.project_name}-${var.environment}-${var.region}-db"
  rg_name             = module.rg.rg_name
  region              = var.region
  principal_id        = module.emp_track_managed_identity.principal_id
  uami_resource_id    = module.emp_track_managed_identity.uami_id
}

module "emp_track_db_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_db_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-db-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region
}

# User Assigned Managed Identity with access Function App to storage account
module "emp_track_managed_identity" {
  source         = "../../modules/managed_identity"
  rg_name        = module.rg.rg_name
  region         = var.region
  principal_name = "${var.project_name}-${var.environment}-${var.region}-sa"
}