resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.cidr]

  private_endpoint_network_policies = "Enabled"

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Sql",
    "Microsoft.KeyVault",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Web"
  ]

  # Dynamic block: if var.delegation_service is null, this block is skipped
  dynamic "delegation" {
    for_each = var.delegation_service != null ? [1] : []
    content {
      name = "delegation"
      service_delegation {
        name    = var.delegation_service
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
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
  depends_on                = [module.nsg]
}