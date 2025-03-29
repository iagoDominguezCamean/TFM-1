resource "azurerm_public_ip" "pub_ip_lb" {
  name                = "pubip-appgtw"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2"]
}

resource "azurerm_virtual_network" "appgtw_vnet" {
  name                = "VNET-APPGTW"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "appgtw_subnet" {
  name                 = "ApplicationGatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.appgtw_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

data "kubernetes_service" "kubenet_service" {
  provider = kubernetes.kubenet
  metadata {
    name      = "app1"
    namespace = "default"
  }
}

data "kubernetes_service" "cilium_service" {
  provider = kubernetes.cilium
  metadata {
    name      = "app1"
    namespace = "default"
  }
}

resource "azurerm_application_gateway" "appgtw" {
  name                = "appgtw-aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = [ "1" ]
  enable_http2        = true
  
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2" 
    capacity = 2
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
    fqdns = [ data.kubernetes_service.kubenet_service.status.0.load_balancer.0.ingress.0.ip, data.kubernetes_service.cilium_service.status.0.load_balancer.0.ingress.0.ip ]
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
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
}
