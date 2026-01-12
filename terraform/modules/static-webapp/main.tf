
resource "azurerm_service_plan" "this" {
  name                = "${var.app_svc_name}-plan"
  resource_group_name = var.rg_name
  location            = var.region
  os_type             = "Linux"
  
  sku_name = "F1" 
}

resource "azurerm_linux_web_app" "this" {
  name                = var.app_svc_name
  resource_group_name = var.rg_name
  location            = var.region
  service_plan_id     = azurerm_service_plan.this.id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_resource_id]
  }

  site_config {
    application_stack {
      docker_image_name = "${var.docker_registry_url}/${var.image_name}:latest"
    }
  }
}