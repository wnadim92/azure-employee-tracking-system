output "vnet_id" {
  value       = module.vnet.vnet_id
  description = "The unique ID of the Virtual Network."
}

output "vnet_name" {
  value       = module.vnet.vnet_name
  description = "The name of the Virtual Network."
}

output "vnet_address_spaces" {
  value       = module.vnet.vnet_address_spaces
  description = "The address spacse assigned to the Virtual Network."
}

output "rg_id" {
  description = "The ID of the resource group."
  value       = module.rg.rg_id
}

output "rg_name" {
  description = "The name of the resource group."
  value       = module.rg.rg_name
}

# Output for Cosmos DB Private DNS Zone
output "cosmos_dns_zone_id" {
  value       = azurerm_private_dns_zone.cosmos.id
  description = "The ID of the Private DNS Zone for Cosmos DB NoSQL."
}

# Output for Web Apps/Function Apps Private DNS Zone
output "web_dns_zone_id" {
  value       = azurerm_private_dns_zone.web.id
  description = "The ID of the Private DNS Zone for App Services and Function Apps."
}

# Optional: Output the Zone Names for reference in records
output "cosmos_dns_zone_name" {
  value = azurerm_private_dns_zone.cosmos.name
}

output "web_dns_zone_name" {
  value = azurerm_private_dns_zone.web.name
}