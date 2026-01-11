resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.region
  resource_group_name = var.rg_name
  address_space       = var.address_spaces
  dns_servers         = var.dns_servers
}