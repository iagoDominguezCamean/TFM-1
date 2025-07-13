terraform {
  required_version = ">=1.0.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "/home/iagodc/.kube/config_cilium"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy               = true
      purge_soft_deleted_secrets_on_destroy      = true
      purge_soft_deleted_certificates_on_destroy = true
      purge_soft_deleted_keys_on_destroy         = true
    }
  }
}
