
module "rg" {
  source  = "../../modules/rg"
  rg_name = "${var.project_name}-${var.environment}-${var.region}-rg" // EX. emptrack-nonprod-eastus-rg
  region  = var.region
}

module "vnet" {
  source         = "../../modules/vnet"
  region         = var.region
  address_spaces = var.vnet_address_spaces
  rg_name        = module.rg.rg_name
  vnet_name      = "${var.project_name}-${var.environment}-${var.region}-vnet" // EX. emptrack-nonprod-eastus-vnet
}
