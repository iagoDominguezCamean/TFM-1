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

# Cilium CNI Helm
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