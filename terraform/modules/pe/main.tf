# 3. Private Endpoint (Uses your subnet module output)
resource "azurerm_private_endpoint" "this" {
  name                = "${var.resource_name}-pe"
  location            = var.region
  resource_group_name = var.rg_name
  # Link directly to the ID output of your subnet module
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.resource_name}-privatelink"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = [var.pe_subresource_type] # "Sql" is the subresource for NoSQL API
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.resource_name}-dns-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}