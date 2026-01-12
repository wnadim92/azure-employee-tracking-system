resource "azurerm_user_assigned_identity" "backend" {
  name                = "${var.project_name}-backend-identity"
  resource_group_name = module.rg.rg_name
  location            = var.region
}

module "storage" {
  source   = "../storage"
  rg_name  = var.rg_name
  region   = var.region
}