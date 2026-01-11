output "app_primary_region_vnet_id" {
  value       = module.app_primary_region.vnet_id
  description = "The unique ID of the Virtual Network."
}

output "app_primary_region_vnet_name" {
  value       = module.app_primary_region.vnet_name
  description = "The name of the Virtual Network."
}

output "app_primary_region_vnet_address_spaces" {
  value       = module.app_primary_region.vnet_address_spaces
  description = "The address spacse assigned to the Virtual Network."
}

output "app_primary_region_rg_id" {
  description = "The ID of the resource group."
  value       = module.app_primary_region.rg_id
}

output "app_primary_region_rg_name" {
  description = "The name of the resource group."
  value       = module.app_primary_region.rg_name
}