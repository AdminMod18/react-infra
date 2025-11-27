resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.project}-logs"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "ai" {
  name                = "${var.project}-ai"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
}

resource "azurerm_container_app_environment" "env" {
  name                        = "${var.project}-env"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_container_app" "frontend" {
  name                         = "${var.project}-app"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 80
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
