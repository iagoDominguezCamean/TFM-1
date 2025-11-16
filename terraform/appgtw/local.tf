locals {
  backend_pool_name              = "backend_pool"
  backend_http_settings_name     = "backend_config"
  gateway_ip_configuration_name  = "IP_config"
  frontend_port_name             = "aks-service"
  frontend_ip_configuration_name = format("%s-feip", azurerm_virtual_network.appgtw_vnet.name)
  http_listener_name             = "http_listener"
  rule_name                      = "rule01"
  probe_name                     = "hp01"

  probes = {
    "hp01" = {
      protocol            = "Http"
      timeout             = 180
      unhealthy_threshold = 15
      interval            = 2
      path                = "/app1"
      host                = "app1.k8s.es"
    }
  }
}
