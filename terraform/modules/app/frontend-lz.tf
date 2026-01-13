

module "emp_track_frontend_vnetintegration_snet" {
  source             = "../../modules/subnet"
  subnet_type        = "private"
  cidr               = var.emp_track_frontend_vnetintegration_snet_cidr
  subnet_name        = "${var.project_name}-${var.environment}-${var.region}-front-vnetinteg-snet"
  rg_name            = module.rg.rg_name
  vnet_name          = module.vnet.vnet_name
  region             = var.region
  delegation_service = "Microsoft.Web/serverFarms"
}

module "emp_track_middletier_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_middletier_pe_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-mid-pe-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region
}

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

module "emp_track_db_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_db_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-${var.region}-db-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
  region      = var.region
}
