terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet_kubenet" {
  name = "vnet-idomingc-kubenet"
  resource_group_name = "idomingc"
  location = "westeurope"
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "kubenet_subnet" {
  name = "kubenetSubnet"
  resource_group_name = "idomingc"
  virtual_network_name = azurerm_virtual_network.vnet_kubenet.name
  address_prefixes = ["10.0.0.0/20"]
}

resource "azurerm_private_dns_zone" "pdns" {
  resource_group_name = "idomingc"
  name = "test.internal"
}

resource "azurerm_user_assigned_identity" "uami" {
  name = "mi-aks"
  resource_group_name = "idomingc"
  location = "westeurope"
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name = "aks-idomingc-test"
  location = "westeurope"
  resource_group_name = "idomingc"
  private_cluster_enabled = true
  dns_prefix_private_cluster = "aks-idomingc-test"
  private_dns_zone_id = azurerm_private_dns_zone.pdns.id

  default_node_pool {
    name = "default"
    vm_size = "Standard_D2_v2"
    node_count = 2
    vnet_subnet_id = azurerm_subnet.kubenet_subnet.id
  }

  network_profile {
    network_plugin = "kubenet"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.uami.id ]
  }
}

resource "local_file" "kube_config" {
  filename = "/home/iagodc/.kube/config"
  content = azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw
  file_permission = "0640"
}