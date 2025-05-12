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

variable "name" {
  description = "value"
  type        = string
  default     = "aks-kubenet"
}

variable "dns_prefix" {
  description = "value"
  type        = string
  default     = "aks-idomingc-kubenet"
}

variable "default_node_pool_name" {
  description = "value"
  type        = string
  default     = "default"
}

variable "vm_size" {
  description = "value"
  type        = string
  default     = "Standard_A2_v2"
}

variable "node_count" {
  description = "value"
  type        = number
  default     = 2
}

variable "service_cidr" {
  description = "value"
  type        = string
  default     = "192.168.0.0/24"
}

variable "dns_service_ip" {
  description = "value"
  type        = string
  default     = "192.168.0.10"
}

# Virtual Network
variable "vnet_name" {
  description = "value"
  type        = string
  default     = "VNET-KUBENET"
}

variable "address_space" {
  description = "value"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "value"
  type        = string
  default     = "kubenetSubnet"
}

variable "address_prefixes" {
  description = "value"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}
