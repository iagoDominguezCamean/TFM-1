resource "azurerm_public_ip" "pub_ip_lb" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = var.public_ip_sku
  zones               = var.public_ip_zones
}

resource "azurerm_virtual_network" "appgtw_vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "appgtw_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.appgtw_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_application_gateway" "appgtw" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones
  enable_http2        = var.enable_http2

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.appgtw_subnet.id
    name      = local.gateway_ip_configuration_name
  }

  frontend_port {
    port = 80
    name = local.frontend_port_name
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pub_ip_lb.id
  }

  backend_address_pool {
    name  = local.backend_pool_name
    fqdns = [data.kubernetes_service.kubenet_service.status.0.load_balancer.0.ingress.0.ip, data.kubernetes_service.cilium_service.status.0.load_balancer.0.ingress.0.ip]
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    probe_name            = local.probe_name
  }

  http_listener {
    frontend_port_name             = local.frontend_port_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    protocol                       = "Http"
    name                           = local.http_listener_name
  }

  request_routing_rule {
    name                       = local.rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    priority                   = 100
  }

  probe {
    name                = local.probe_name
    protocol            = "Http"
    timeout             = 180
    unhealthy_threshold = 15
    interval            = 2
    path                = "/app1"
    host                = "app1.k8s.es"
  }
}
