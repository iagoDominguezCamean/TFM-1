resource "azurerm_public_ip" "pub_ip_lb" {
  count = var.create_appgtw ? 1 : 0
  
  name                = "pubip-lb-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_virtual_network" "appgtw_vnet" {
  count = var.create_appgtw ? 1 : 0

  name                = "VNET-APPGTW"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "appgtw_subnet" {
  count = var.create_appgtw ? 1 : 0

  name                 = "ApplicationGatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appgtw_vnet[0].name
  address_prefixes     = ["10.0.0.0/24"]
}

data "kubernetes_service" "kubenet_service" {
  count = var.create_appgtw ? 1 : 0

  provider = kubernetes.kubenet
  metadata {
    name      = "app1"
    namespace = "default"
  }
}

data "kubernetes_service" "cilium_service" {
  count = var.create_appgtw ? 1 : 0

  provider = kubernetes.cilium
  metadata {
    name      = "app1"
    namespace = "default"
  }
}

resource "azurerm_application_gateway" "appgtw" {
  count = var.create_appgtw ? 1 : 0

  name                = "appgtw-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  zones               = [ "1" ]
  enable_http2        = true
  
  
  # autoscale_configuration {
  #   min_capacity = 2
  #   max_capacity = 2
  # }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2" 
    capacity = 2
  }

  gateway_ip_configuration {
    subnet_id = azurerm_subnet.appgtw_subnet[0].id
    name      = "IP_config"
  }

  frontend_port {
    port = 80
    name = "aks-service"
  }

  frontend_ip_configuration {
    name                 = format("%s-feip", azurerm_virtual_network.appgtw_vnet[0].name)
    public_ip_address_id = azurerm_public_ip.pub_ip_lb[0].id
  }

  backend_address_pool {
    name  = "backend_pool"
    fqdns = [ data.kubernetes_service.kubenet_service[0].status.0.load_balancer.0.ingress.0.ip, data.kubernetes_service.cilium_service[0].status.0.load_balancer.0.ingress.0.ip ]
  }

  backend_http_settings {
    name                  = "backend_config"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
  }

  http_listener {
    frontend_port_name             = "aks-service"
    frontend_ip_configuration_name = format("%s-feip", azurerm_virtual_network.appgtw_vnet[0].name)
    protocol                       = "Http"
    name                           = "http_listener"
  }

  request_routing_rule {
    name                       = "r1"
    rule_type                  = "Basic"
    http_listener_name         = "http_listener"
    backend_address_pool_name  = "backend_pool"
    backend_http_settings_name = "backend_config"
    priority                   = 100
  }
}
