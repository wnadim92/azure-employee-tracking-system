#subnets

#middle tier private endpoint subnet
module "emp_track_middletier_pe_snet" {
  source      = "../../modules/subnet"
  subnet_type = "public"
  cidr        = var.emp_track_middletier_pe_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-btier-pe-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
}

#middle tier vnet integration subnet
module "emp_track_middletier_vnetintegration_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_middletier_vnetintegration_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-front-vnetinteg-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
}

#db subnet
module "emp_track_db_snet" {
  source      = "../../modules/subnet"
  subnet_type = "private"
  cidr        = var.emp_track_db_snet_cidr
  subnet_name = "${var.project_name}-${var.environment}-db-snet"
  rg_name     = module.rg.rg_name
  vnet_name   = module.vnet.vnet_name
}