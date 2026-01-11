#subnets

#front end public appgw subnet
module "emp_track_frontend_appgw_snet" {
    source = "../../modules/subnet"
    subnet_type = "public"
    cidr = var.emp_track_frontend_appgw_snet_cidr
    subnet_name = "${var.project_name}-${var.environment}-appgw-pub-snet"
    rg_name = module.rg.rg_name
    vnet_name = module.vnet.vnet_name
}

#front end private endpoint subnet
module "emp_track_frontend_pe_snet" {
    source = "../../modules/subnet"
    subnet_type = "private"
    cidr = var.emp_track_frontend_pe_snet_cidr
    subnet_name = "${var.project_name}-${var.environment}-front-pe-snet"
    rg_name = module.rg.rg_name
    vnet_name = module.vnet.vnet_name
}

#front end vnet integration subnet
module "emp_track_frontend_vnetintegration_snet" {
    source = "../../modules/subnet"
    subnet_type = "private"
    cidr = var.emp_track_frontend_vnetintegration_snet_cidr
    subnet_name = "${var.project_name}-${var.environment}-front-vnetinteg-snet"
    rg_name = module.rg.rg_name
    vnet_name = module.vnet.vnet_name
}
