# The primary endpoint for the Function App connection string (Identity-based)
output "cosmosdb_endpoint" {
  description = "The endpoint used to connect to the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.endpoint
}

# The Account Name used for Role Definitions and App Settings
output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.name
}

# The full Resource ID used for RBAC scoping in the Function App module
output "cosmosdb_id" {
  description = "The full Azure Resource ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.id
}

# The SQL Database name
output "cosmosdb_database_name" {
  description = "The name of the SQL Database."
  value       = azurerm_cosmosdb_sql_database.this.name
}

# The SQL Container name
output "cosmosdb_container_name" {
  description = "The name of the SQL Container."
  value       = azurerm_cosmosdb_sql_container.this.name
}

# # The Private Endpoint IP (if needed for firewall troubleshooting)
# output "cosmosdb_private_ip" {
#   description = "The private IP address of the Cosmos DB private endpoint."
#   value       = module.pe.private_ip # Assumes your 'pe' module has a 'private_ip' output
# }
