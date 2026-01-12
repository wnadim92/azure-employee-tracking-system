
resource "azurerm_service_plan" "this" {
  name                = "${var.app_svc_name}-plan"
  resource_group_name = var.rg_name
  location            = var.region
  os_type             = "Linux"

  sku_name = "S1"
}

resource "azurerm_linux_web_app" "this" {
  name                = var.app_svc_name
  resource_group_name = var.rg_name
  location            = var.region
  service_plan_id     = azurerm_service_plan.this.id

  virtual_network_subnet_id = var.vnet_integration_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_resource_id]
  }

  site_config {
    vnet_route_all_enabled = true

    application_stack {
      docker_image_name = "${var.docker_registry_url}/${var.image_name}:latest"
    }
  }

  app_settings = {
    "WEBSITE_DNS_SERVER" = "168.63.129.16" # Required for Azure DNS
  }
}