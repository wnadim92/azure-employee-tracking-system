output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The unique ID of the created Virtual Network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the created Virtual Network."
}

output "vnet_address_spaces" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "The address space assigned to the Virtual Network."
}