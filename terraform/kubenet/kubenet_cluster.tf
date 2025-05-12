resource "azurerm_virtual_network" "vnet_kubenet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "kubenet_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_kubenet.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name           = var.default_node_pool_name
    vm_size        = var.vm_size
    node_count     = var.node_count
    vnet_subnet_id = azurerm_subnet.kubenet_subnet.id
  }

  network_profile {
    network_plugin = "kubenet"
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
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
