
#front end app service React SPA

module "emp_track_frontend_vnetintegration_snet" {
    source      = "../../modules/subnet"
    subnet_type = "private"
    cidr        = var.emp_track_frontend_vnetintegration_snet_cidr
    subnet_name = "${var.project_name}-${var.environment}-${var.region}-front-vnetinteg-snet"
    rg_name     = module.rg.rg_name
    vnet_name   = module.vnet.vnet_name
    region      = var.region       
    delegation_service = "Microsoft.Web/serverFarms"
}
