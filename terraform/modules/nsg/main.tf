resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.region
  resource_group_name = var.rg_name
}

# Define rules outside the NSG resource so can support tacking on custom NSG rules to the nsg via the module
resource "azurerm_network_security_rule" "base_rule_set" {
  for_each = var.nsg_type == "public" ? var.public_rules : var.private_rules

  name                        = each.key
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.port
  
  # Logic: If public, allow all (*). If private, use the RFC 1918 default list.
  source_address_prefix       = var.nsg_type == "public" ? "*" : null
  source_address_prefixes     = var.nsg_type == "public" ? null : var.rfc_1918_prefixes

  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}
