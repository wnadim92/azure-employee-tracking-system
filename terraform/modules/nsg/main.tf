resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.region
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "base_rule_set" {
  for_each = var.nsg_type == "public" ? var.public_rules : var.private_rules

  name                        = each.key
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.port
  
  source_address_prefix       = var.nsg_type == "public" ? "*" : null
  source_address_prefixes     = var.nsg_type == "public" ? null : var.rfc_1918_prefixes

  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}
