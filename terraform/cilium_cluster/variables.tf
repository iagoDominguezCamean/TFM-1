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
