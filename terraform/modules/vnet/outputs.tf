output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "The unique ID of the provisioned Virtual Network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the provisioned Virtual Network."
}

output "vnet_address_spaces" {
  value       = azurerm_virtual_network.this.address_space
  description = "The address space assigned to the Virtual Network."
}