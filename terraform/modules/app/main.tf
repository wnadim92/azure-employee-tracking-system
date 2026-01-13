
module "emp_track_frontend_appsvc" {
  source              = "../../modules/static-webapp"
  app_svc_name        = "${var.project_name}-${var.environment}-${var.region}-appsvc"
  uami_resource_id    = module.emp_track_managed_identity.uami_id
  rg_name             = module.rg.rg_name
  region              = var.region
  docker_registry_url = var.docker_registry_url
  image_name          = var.frontend_image_name
  image_tag           = var.image_tag
  backend_url         = "https://${var.project_name}-${var.environment}-${var.region}-funcapp.azurewebsites.net/api"
}

module "emp_track_middle_funcapp" {
  source                         = "../../modules/funcapp-docker"
  funcapp_name                   = "${var.project_name}-${var.environment}-${var.region}-funcapp"
  pe_subnet_id                   = module.emp_track_middletier_pe_snet.subnet_id
  vnet_integration_subnet_id     = module.emp_track_middletier_vnetintegration_snet.subnet_id
  uami_resource_id               = module.emp_track_managed_identity.uami_id
  uami_client_id                 = module.emp_track_managed_identity.client_id
  uami_principal_id              = module.emp_track_managed_identity.principal_id
  rg_name                        = module.rg.rg_name
  region                         = var.region
  cosmosdb_endpoint              = module.emp_track_db.cosmosdb_endpoint
  docker_registry_url            = var.docker_registry_url
  image_name                     = var.backend_image_name
  image_tag                      = var.image_tag
  database_name                  = "${var.project_name}-${var.environment}-${var.region}-db"
  allowed_origins                = ["https://${var.project_name}-${var.environment}-${var.region}-appsvc.azurewebsites.net"]
  public_network_access_enabled  = true
  blob_dns_zone_id               = azurerm_private_dns_zone.blob.id
  file_dns_zone_id               = azurerm_private_dns_zone.file.id
  table_dns_zone_id              = azurerm_private_dns_zone.table.id
  queue_dns_zone_id              = azurerm_private_dns_zone.queue.id
}

module "emp_track_managed_identity" {
  source         = "../../modules/managed_identity"
  rg_name        = module.rg.rg_name
  region         = var.region
  principal_name = "${var.project_name}-${var.environment}-${var.region}-sa"
}

# cosmos db
module "emp_track_db" {
  source              = "../../modules/cosmosdb"
  subnet_id           = module.emp_track_db_pe_snet.subnet_id
  db_name             = "${var.project_name}-${var.environment}-${var.region}-db"
  rg_name             = module.rg.rg_name
  region              = var.region
  private_dns_zone_id = azurerm_private_dns_zone.cosmos.id
  principal_id        = module.emp_track_managed_identity.principal_id
}
