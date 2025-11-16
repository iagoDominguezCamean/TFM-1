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

# Application Gateway
variable "name" {
  description = "value"
  type        = string
  default     = "appgtw-aks"
}

variable "zones" {
  description = "value"
  type        = list(string)
  default     = ["1"]
}

variable "enable_http2" {
  description = "value"
  type        = bool
  default     = true
}

variable "sku_name" {
  description = "value"
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "value"
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "value"
  type        = number
  default     = 2
}

# Public IP
variable "public_ip_name" {
  description = "value"
  type        = string
  default     = "pubip-appgtw"
}

variable "allocation_method" {
  description = "value"
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "value"
  type        = string
  default     = "Standard"
}

variable "public_ip_zones" {
  description = "value"
  type        = list(string)
  default     = ["1"]
}

# Virtual Network
variable "vnet_name" {
  description = "value"
  type        = string
  default     = "VNET-APPGTW"
}

variable "vnet_address_space" {
  description = "value"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "value"
  type        = string
  default     = "ApplicationGatewaySubnet"
}

variable "subnet_address_prefixes" {
  description = "value"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "probes" {
  description = "Map with probes to be defined"
  type = map(object({
    protocol            = optional(string, "Http")
    timeout             = optional(number, 180)
    unhealthy_threshold = optional(number, 15)
    interval            = optional(number, 2)
    path                = string
    host                = string
  }))
  default = {}
}

# Kubernetes services
