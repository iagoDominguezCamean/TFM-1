resource "azurerm_virtual_network" "vnet_cilium" {
  name                = "VNET-CILIUM"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "cilium_node_subnet" {
  name                 = "CiliumNodeSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cilium.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_kubernetes_cluster" "k8s_cilium" {
  name                = "aks-cilium"
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = "aks-idomingc-cilium"

  default_node_pool {
    node_count     = 2
    name           = "azurecilium"
    vm_size        = "Standard_A2_v2"
    vnet_subnet_id = azurerm_subnet.cilium_node_subnet.id
  }

  network_profile {
    network_plugin = "none"
    service_cidr   = "10.20.0.0/24"
    dns_service_ip = "10.20.0.10"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [web_app_routing]
  }
}

resource "local_file" "kube_config_cilium" {
  filename        = "/home/iagodc/.kube/config_cilium"
  content         = azurerm_kubernetes_cluster.k8s_cilium.kube_config_raw
  file_permission = "0640"
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s_cilium.kubelet_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.k8s_cilium]
}
