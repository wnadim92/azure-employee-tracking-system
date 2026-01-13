output "webapp_name" {
  value = module.emp_track_frontend_appsvc.name
}

output "funcapp_name" {
  value = module.emp_track_middle_funcapp.name
}

output "vnet_id" {
  value = module.vnet.id
}

output "vnet_name" {
  value = module.vnet.name
}

output "vnet_address_spaces" {
  value = module.vnet.vnet_address_spaces
}

output "rg_id" {
  value = module.rg.id
}

output "rg_name" {
  value = module.rg.name
}