resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_kubenet" {
  name                = "vnet-idomingc-kubenet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "kubenet_subnet" {
  name                 = "kubenetSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_kubenet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "aks-idomingc-test"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-idomingc-kubenet"
  # private_cluster_enabled = true
  # dns_prefix_private_cluster = "aks-idomingc-kubenet"

  default_node_pool {
    name           = "default"
    vm_size        = "Standard_A2_v2"
    node_count     = 2
    vnet_subnet_id = azurerm_subnet.kubenet_subnet.id
  }

  network_profile {
    network_plugin = "kubenet"
    service_cidr   = "192.168.0.0/24"
    dns_service_ip = "192.168.0.10"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kube_config" {
  filename        = "/home/iagodc/.kube/config"
  content         = azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw
  file_permission = "0640"
}

resource "kubernetes_manifest" "echo_server" {
  count = var.create_cilium_cluster ? 1 : 0
  
  manifest = yamldecode(file("../k8s/app1-pod.yaml"))
}