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
  description = "value"
  type        = string
  default     = "LRS"
}

variable "sa_velero_tier" {
  description = "value"
  type        = string
  default     = "Standard"
}

variable "enable_velero" {
  description = "value"
  type        = bool
  default     = false
}
