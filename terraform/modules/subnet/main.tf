resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidr]
  
  # Recommended for 2026: explicit policy management
  private_endpoint_network_policies = "Enabled"
}

# Associate the NSG with this Subnet
resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = var.nsg_id
}

module "thisnsg" {
    source = "../nsg"
    nsg_name = "${var.subnet_name}-nsg"
    rg_name  = var.rg_name
    region   = var.region
    nsg_type = var.subnet_type == "public" ? "public" : "private"
}