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

variable "install_cilium" {
  description = "Control if install cilium or not."
  type        = bool
  default     = false
}