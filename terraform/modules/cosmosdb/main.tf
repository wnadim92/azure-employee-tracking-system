
resource "azurerm_cosmosdb_account" "this" {
  name                = lower("${var.db_name}")
  location            = var.region
  resource_group_name = var.rg_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  free_tier_enabled = true

  public_network_access_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.region
    failover_priority = 0
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_resource_id]
  }

  default_identity_type = join("=", ["UserAssignedIdentity", var.uami_resource_id])
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = var.db_name
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "this" {
  name                = var.db_name
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name
  partition_key_paths = ["/id"]
}

# 4. Resolve and Assign Built-in Data Role
data "azurerm_cosmosdb_sql_role_definition" "data_contributor" {
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = "00000000-0000-0000-0000-000000000002" # built in data role
}

resource "azurerm_cosmosdb_sql_role_assignment" "this" {
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = data.azurerm_cosmosdb_sql_role_definition.data_contributor.id
  principal_id        = var.principal_id
  scope               = azurerm_cosmosdb_account.this.id
}