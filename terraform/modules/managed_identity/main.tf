resource "azurerm_user_assigned_identity" "this" {
  name                = var.principal_name
  resource_group_name = var.rg_name
  location            = var.region
}
