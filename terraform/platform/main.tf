
module "rg" {
    source = "../modules/rg"
    rg_name = "${var.project_name}-${var.environment}-rg"
    region = var.region
}

module "vnet" {
    source = "../modules/vnet"
    region = var.region
    address_spaces = var.address_spaces
    rg_name = module.rg.rg_name
}