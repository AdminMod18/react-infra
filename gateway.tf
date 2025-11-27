resource "azurerm_public_ip" "gateway_ip" {
  name                = "${var.project}-gateway-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gateway" {
  name                = "${var.project}-agw"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = var.gateway_sku
    tier     = var.gateway_sku
    capacity = var.gateway_capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.gateway_subnet.id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "publicIpAddress"
    public_ip_address_id = azurerm_public_ip.gateway_ip.id
  }

  backend_address_pool {
    name  = "aca-backend"
    fqdns = [azurerm_container_app.frontend.latest_revision_fqdn]
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "publicIpAddress"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routingRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "aca-backend"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }
}