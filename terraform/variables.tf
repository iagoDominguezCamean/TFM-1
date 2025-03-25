variable "create_cilium_cluster" {
  description = "True to create the new cluster"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Resource group for aks clusters"
  type        = string
  default     = "idomingc"
}

variable "location" {
  description = "Location of the resources"
  type        = string
  default     = "westeurope"
}