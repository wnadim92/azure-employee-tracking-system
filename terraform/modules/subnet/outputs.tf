output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "The unique ID of the subnet."
}

output "subnet_cidr" {
  value       = azurerm_subnet.this.address_prefixes
  description = "The cidr assigned to the subnet."
}

output "nsg_id" {
  value       = module.nsg.nsg_id
  description = "The nsg id."
}