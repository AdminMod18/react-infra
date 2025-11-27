resource "azurerm_container_app" "frontend" {
  name                         = "${var.project}-app"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name   = "frontend"
      image  = var.docker_image
      cpu    = 1
      memory = "2Gi"
    }
  }
}
