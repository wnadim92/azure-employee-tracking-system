resource "azurerm_storage_account" "this" {
  name                     = lower(replace("${var.project_name}${var.environment}sa", "-", ""))
  resource_group_name      = var.rg_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2" # Mandatory for 2026 features
  
  # SECURITY: Deny all public access
  public_network_access_enabled = false
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
}

# Private Endpoints for each sub-service
locals {
  storage_pe_map = {
    blob  = var.blob_dns_zone_id
    file  = var.file_dns_zone_id
    table = var.table_dns_zone_id
    queue = var.queue_dns_zone_id
  }
}

module "storage_pe" {
  for_each = local.storage_pe_map
  
  source                         = "../pe" # Your existing PE module
  resource_name                  = "${azurerm_storage_account.this.name}-${each.key}"
  rg_name                        = var.rg_name
  region                         = var.region
  subnet_id                      = var.subnet_id
  private_connection_resource_id = azurerm_storage_account.this.id
  pe_subresource_type            = [each.key]
  private_dns_zone_id            = [each.value]
}