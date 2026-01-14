
# React Docker Based App Service
module "emp_track_frontend_appsvc" {
  source              = "../../modules/static-webapp"
  app_svc_name        = "${var.project_name}-${var.environment}-${var.region}-appsvc"
  uami_resource_id    = module.emp_track_managed_identity.uami_id
  rg_name             = module.rg.rg_name
  region              = var.region
  docker_registry_url = var.docker_registry_url
  image_name          = var.frontend_image_name
  image_tag           = var.image_tag
  backend_url         = "https://${var.project_name}-${var.environment}-${var.region}-funcapp.azurewebsites.net"
}

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
