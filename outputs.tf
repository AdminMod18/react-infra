output "public_url" {
  value = "http://${azurerm_public_ip.gateway_ip.ip_address}"
}
