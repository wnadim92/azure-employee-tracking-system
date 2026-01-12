output "principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "The Principal ID of the User Assigned Managed Identity."
}

# 2. Use this for App Settings (Function App Configuration)
output "client_id" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "The Client ID used in app_settings to select this identity."
}

output "uami_id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "The full Resource ID of the User Assigned Identity."
}
