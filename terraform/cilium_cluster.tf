resource "azurerm_public_ip" "pub_ip_lb" {
  name                = "pubip-lb-aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb_aks" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "lb-aks"

  frontend_ip_configuration {
    name                 = "PublicIPAddres"
    public_ip_address_id = azurerm_public_ip.pub_ip_lb.id
    zones = [ "1", "2", "3" ]
  }
}

resource "azurerm_virtual_network" "vnet_cilium" {
  count = var.create_cilium_cluster ? 1 : 0

  name                = "vnet-idomingc-cilium"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [ "10.1.0.0/16" ]
}

resource "azurerm_subnet" "cilium_node_subnet" {
  count = var.create_cilium_cluster ? 1 : 0
  
  name                 = "CiliumNodeSubnet"
  resource_group_name  = var.location
  virtual_network_name = azurerm_virtual_network.vnet_cilium[0].name
  address_prefixes     = [ "10.1.0.0/24" ]
}

resource "azurerm_kubernetes_cluster" "k8s_cilium" {
  count = var.create_cilium_cluster ? 1 : 0

  name                = "k8s-idomingc-cilium"
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = "aks-idomingc-cilium"

  default_node_pool {
    node_count     = 2
    name           = "azurecilium"
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.cilium_node_subnet[0].id
  }
  
  network_profile {
    network_plugin      = "azure"
    network_data_plane  = "cilium"
    network_plugin_mode = "overlay"
    pod_cidr            = "10.10.0.0/22"
    service_cidr        = "10.20.0.0/24"
    dns_service_ip      = "10.20.0.10"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kube_config_cilium" {
  count = var.create_cilium_cluster ? 1 : 0

  filename        = "/home/iagodc/.kube/config_cilium"
  content         = azurerm_kubernetes_cluster.k8s_cilium[0].kube_config_raw
  file_permission = "0640"
}