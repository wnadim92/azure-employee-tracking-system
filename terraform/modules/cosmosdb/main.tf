# 1. Cosmos DB Account with Free Tier
resource "azurerm_cosmosdb_account" "this" {
  name                = lower("${var.db_name}")
  location            = var.region
  resource_group_name = var.rg_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # ENABLE FREE TIER (1000 RU/s + 25GB Storage Free)
  free_tier_enabled = true 

  public_network_access_enabled = false

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.region
    failover_priority = 0
  }
}

# db private endpoint
module "pe" {
    source                         = "../pe"
    resource_name                  = "${var.db_name}"
    rg_name                        = var.rg_name
    region                         = var.region
    subnet_id                      = var.subnet_id
    private_connection_resource_id = azurerm_cosmosdb_account.this.id
    pe_subresource_type            = ["Sql"]
    private_dns_zone_id            = var.private_dns_zone_id
}

# 2. SQL Database with SHARED throughput
resource "azurerm_cosmosdb_sql_database" "this" {
  name                = "${var.db_name}"
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  
  # Set throughput here so all containers share it
  # 400 is the minimum, well within the 1000 RU free limit
  throughput = 400 
}

# 3. SQL Container (Remove individual throughput)
resource "azurerm_cosmosdb_sql_container" "this" {
  name                = "${var.db_name}"
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name
  partition_key_path  = "/id"
  }

# 4. Resolve and Assign Built-in Data Role
# This replaces the "random zeros" with a dynamic reference
data "azurerm_cosmosdb_sql_role_definition" "data_contributor" {
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = "00000000-0000-0000-0000-000000000002" # Constant for 'Contributor'
}

resource "azurerm_cosmosdb_sql_role_assignment" "this" {
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = data.azurerm_cosmosdb_sql_role_definition.data_contributor.id
  principal_id        = var.backend_principal_id
  scope               = azurerm_cosmosdb_account.this.id
}