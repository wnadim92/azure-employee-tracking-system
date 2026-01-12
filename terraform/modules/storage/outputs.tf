# The name is used for the WEBSITE_CONTENTSHARE setting
output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.this.name
}

# The ID is used for role assignments (RBAC)
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.this.id
}

# Used for AzureWebJobsStorage app setting
output "primary_connection_string" {
  description = "The connection string for the storage account"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

# Used for WEBSITE_CONTENTAZUREFILECONNECTIONSTRING app setting
output "primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}