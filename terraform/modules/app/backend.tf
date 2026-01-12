#subnets

#middle tier private endpoint subnet
module "emp_track_middletier_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_middletier_pe_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-mid-pe-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region  
}

#middle tier vnet integration subnet
module "emp_track_middletier_vnetintegration_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_middletier_vnetintegration_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-mid-vnetinteg-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region
  delegation_service = "Microsoft.Web/serverFarms"
}

#db pe subnet
module "emp_track_db_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_db_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-db-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region
}

# cosmos db
module "emp_track_managed_identity" {
  source                               = "../../modules/managed_identity"
  rg_name                              = module.rg.rg_name
  region                               = var.region
  principal_name                       = "${var.project_name}-${var.environment}-${var.region}-sa"
}

# backend function app
module "emp_track_middle_funcapp" {
  source                               = "../../modules/funcapp"
  funcapp_name                         = "${var.project_name}-${var.environment}-${var.region}-funcapp"
  pe_subnet_id                         = modules.emp_track_middletier_pe_snet.subnet_id
  vnet_integration_subnet_id           = moddule.emp_track_middletier_vnetintegration_snet.subnet_id
  uami_resource_id                     = module.emp_track_managed_identity.uami_id
  uami_client_id                       = module.emp_track_managed_identity.client_id
  uami_principal_id                    = module.emp_track_managed_identity.principal_id
  rg_name                              = module.rg.rg_name
  region                               = var.region
  cosmosdb_endpoint                    = module.emp_track_db.cosmosdb_endpoint
}

# cosmos db
module "emp_track_db" {
  source                               = "../../modules/cosmosdb"
  subnet_id                            = modules.emp_track_db_pe_snet.subnet_id
  db_name                              = "${var.project_name}-${var.environment}-${var.region}-db"
  rg_name                              = module.rg.rg_name
  region                               = var.region
  private_dns_zone_id                  = azurerm_private_dns_zone.cosmos.name
  backend_principal_id                 = module.emp_track_managed_identity.principal_id
}




