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
variable "install_cilium" {
  description = "Control if install cilium or not."
  type        = bool
  default     = false
}

variable "pod_cidr_list" {
  description = "value"
  type        = string
  default     = "10.10.0.0/22"
}

variable "hubble_relay_enabled" {
  description = "value"
  type        = string
  default     = "false"
}
