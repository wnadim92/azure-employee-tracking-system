
output "webapp_name" {
  description = "The name of the web app."
  value       = module.app_primary_region.webapp_name
}

output "funcapp_name" {
  description = "The name of the function app."
  value       = module.app_primary_region.funcapp_name
}
