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