terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.36"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "kubernetes" {
  alias       = "kubenet"
  config_path = "/home/iagodc/.kube/config"
}

provider "kubernetes" {
  alias       = "cilium"
  config_path = "/home/iagodc/.kube/config_cilium"
}