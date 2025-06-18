variable "resource_group_name" {
  description = "Resource group for aks clusters"
  type        = string
  default     = "idomingc"
}

variable "location" {
  description = "Location of the resources"
  type        = string
  default     = "northeurope"
}

variable "sa_velero_replication_type" {
  description = "Velero storage account replication type"
  type        = string
  default     = "LRS"
}

variable "sa_velero_tier" {
  description = "Velero storage account tier"
  type        = string
  default     = "Standard"
}

variable "enable_velero" {
  description = "True to enable velero"
  type        = bool
  default     = false
}

variable "acr_name" {
  description = "Name for the azure container registry"
  type        = string
  default     = "acridomingc"
}

variable "pod_cidr_list" {
  description = "Pod CIDR address"
  type        = string
  default     = "10.10.0.0/22"
}

variable "hubble_relay_enabled" {
  description = "True to enable hubble."
  type        = string
  default     = "false"
}