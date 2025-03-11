resource "azurerm_virtual_network" "vnet_cilium" {
  count = var.create_cilium_cluster ? 1 : 0

  name = "vnet-idomingc-cilium"
  resource_group_name = "idomingc"
  location = "westeurope"
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "cilium_node_subnet" {
  count = var.create_cilium_cluster ? 1 : 0
  
  name = "CiliumNodeSubnet"
  resource_group_name = "idomingc"
  virtual_network_name = azurerm_virtual_network.vnet_cilium[0].name
  address_prefixes = [ "10.240.0.0/20" ]
}

resource "azurerm_kubernetes_cluster" "k8s_cilium" {
  count = var.create_cilium_cluster ? 1 : 0

  name = "k8s-idomingc-cilium"
  resource_group_name = "idomingc"
  location = "westeurope"
  private_cluster_enabled = true
  dns_prefix_private_cluster = "aks-idomingc-test-cilium"
  private_dns_zone_id = azurerm_private_dns_zone.pdns.id

  default_node_pool {
    node_count = 2
    name = "azurecilium"
    vm_size = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.cilium_node_subnet[0].id
  }
  
  network_profile {
    network_plugin = "azure"
    network_data_plane = "cilium"
    network_plugin_mode = "overlay"
    pod_cidr = "10.10.0.0/22"
    service_cidr = "10.20.0.0/24"
    dns_service_ip = "10.20.0.10"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.uami.id ]
  }
}

resource "local_file" "kube_config_cilium" {
  count = var.create_cilium_cluster ? 1 : 0

  filename = "/home/iagodc/.kube/config_cilium"
  content = azurerm_kubernetes_cluster.k8s_cilium[0].kube_config_raw
  file_permission = "0640"
}