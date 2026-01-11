resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.cidr]

  private_endpoint_network_policies = "Enabled"
}

module "nsg" {
  source   = "../nsg"
  nsg_name = "${var.subnet_name}-nsg"
  rg_name  = var.rg_name
  region   = var.region
  nsg_type = var.subnet_type == "public" ? "public" : "private"
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = module.nsg.nsg_id
}