resource "azurerm_virtual_network" "vnet_cilium" {
  name                = "vnet-idomingc-cilium"
  resource_group_name = var.resource_group_name
  location            = "northeurope"
  address_space       = [ "10.1.0.0/16" ]
}

resource "azurerm_subnet" "cilium_node_subnet" {  
  name                 = "CiliumNodeSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cilium.name
  address_prefixes     = [ "10.1.0.0/24" ]
}

resource "azurerm_kubernetes_cluster" "k8s_cilium" {
  name                = "k8s-idomingc-cilium"
  resource_group_name = var.resource_group_name
  location            = "northeurope"
  dns_prefix          = "aks-idomingc-cilium"

  default_node_pool {
    node_count     = 2
    name           = "azurecilium"
    vm_size        = "Standard_A2_v2"
    vnet_subnet_id = azurerm_subnet.cilium_node_subnet.id
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
  filename        = "/home/iagodc/.kube/config_cilium"
  content         = azurerm_kubernetes_cluster.k8s_cilium.kube_config_raw
  file_permission = "0640"
}