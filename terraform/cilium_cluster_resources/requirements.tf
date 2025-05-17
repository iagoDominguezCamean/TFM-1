terraform {
  required_version = ">=1.0.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "/home/iagodc/.kube/config_cilium"
  }
}
