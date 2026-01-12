
module "rg" {
  source  = "../../modules/rg"
  rg_name = "${var.project_name}-${var.environment}-${var.region}-rg" // EX. emptrack-nonprod-eastus-rg
  region  = var.region
}

module "vnet" {
  source         = "../../modules/vnet"
  region         = var.region
  address_spaces = var.vnet_address_spaces
  rg_name        = module.rg.rg_name
  vnet_name      = "${var.project_name}-${var.environment}-${var.region}-vnet" // EX. emptrack-nonprod-eastus-vnet
}

resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = module.rg.rg_name
}

# DNS Zone for App Service and Function Apps
resource "azurerm_private_dns_zone" "web" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = module.rg.rg_name
}

# Link Cosmos DNS to your VNet
resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_link" {
  name                  = "${var.project_name}-${var.environment}-${var.region}-cosmos-dnszone-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = module.vnet.vnet_id # Reference your existing VNet module
}

resource "azurerm_private_dns_zone_virtual_network_link" "web_link" {
  name                  = "${var.project_name}-${var.environment}-${var.region}-web-dnszone-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.web.name
  virtual_network_id    = module.vnet.vnet_id
}

# Blob DNS Zone
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.rg.rg_name
}

# File DNS Zone (Required for Function App code storage)
resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = module.rg.rg_name
}

# Table DNS Zone
resource "azurerm_private_dns_zone" "table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = module.rg.rg_name
}

# Queue DNS Zone
resource "azurerm_private_dns_zone" "queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = module.rg.rg_name
}

# Blob Link
resource "azurerm_private_dns_zone_virtual_network_link" "blob_link" {
  name                  = "${var.project_name}-${var.environment}-blob-dns-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = module.vnet.vnet_id
}

# File Link
resource "azurerm_private_dns_zone_virtual_network_link" "file_link" {
  name                  = "${var.project_name}-${var.environment}-file-dns-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = module.vnet.vnet_id
}

# Table Link
resource "azurerm_private_dns_zone_virtual_network_link" "table_link" {
  name                  = "${var.project_name}-${var.environment}-table-dns-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.table.name
  virtual_network_id    = module.vnet.vnet_id
}

# Queue Link
resource "azurerm_private_dns_zone_virtual_network_link" "queue_link" {
  name                  = "${var.project_name}-${var.environment}-queue-dns-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.queue.name
  virtual_network_id    = module.vnet.vnet_id
}