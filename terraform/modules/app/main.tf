
# react docker baesd frontend vnet integrated to call middle tier pe 
module "emp_track_frontend_appsvc" {
  source                               = "../../modules/appsvc"
  app_svc_name                         = "${var.project_name}-${var.environment}-${var.region}-appsvc"
  vnet_integration_subnet_id           = module.emp_track_frontend_vnetintegration_snet.subnet_id
  uami_resource_id                     = module.emp_track_managed_identity.uami_id
  rg_name                              = module.rg.rg_name
  region                               = var.region
  docker_registry_url                  = var.docker_registry_url
  image_name                           = var.frontend_image_name
}

# fastAPI docker based vnet integrated to call cosmos db pe, this function app is also on private endpoint 
module "emp_track_middle_funcapp" {
  source                               = "../../modules/funcapp"
  funcapp_name                         = "${var.project_name}-${var.environment}-${var.region}-funcapp"
  pe_subnet_id                         = module.emp_track_middletier_pe_snet.subnet_id
  vnet_integration_subnet_id           = module.emp_track_middletier_vnetintegration_snet.subnet_id
  uami_resource_id                     = module.emp_track_managed_identity.uami_id
  uami_client_id                       = module.emp_track_managed_identity.client_id
  uami_principal_id                    = module.emp_track_managed_identity.principal_id
  rg_name                              = module.rg.rg_name
  region                               = var.region
  cosmosdb_endpoint                    = module.emp_track_db.cosmosdb_endpoint
  docker_registry_url                  = var.docker_registry_url
  image_name                           = var.backend_image_name
  sites_dns_zone_id                    = azurerm_private_dns_zone.web.name
  blob_dns_zone_id                     = azurerm_private_dns_zone.blob.name
  file_dns_zone_id                     = azurerm_private_dns_zone.file.name
  table_dns_zone_id                    = azurerm_private_dns_zone.table.name
  queue_dns_zone_id                    = azurerm_private_dns_zone.queue.name
}

module "emp_track_managed_identity" {
  source                               = "../../modules/managed_identity"
  rg_name                              = module.rg.rg_name
  region                               = var.region
  principal_name                       = "${var.project_name}-${var.environment}-${var.region}-sa"
}

# cosmos db
module "emp_track_db" {
  source                               = "../../modules/cosmosdb"
  subnet_id                            = module.emp_track_db_pe_snet.subnet_id
  db_name                              = "${var.project_name}-${var.environment}-${var.region}-db"
  rg_name                              = module.rg.rg_name
  region                               = var.region
  private_dns_zone_id                  = azurerm_private_dns_zone.cosmos.name
  principal_id                         = module.emp_track_managed_identity.principal_id
}
