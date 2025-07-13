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

variable "sku" {
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "name" {
  description = "Azure container registry name"
  type        = string
  default     = "acridomingc"
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false.value"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for the container registry."
  type        = bool
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}

variable "zone_redundancy_enabled" {
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "georeplications" {
  description = "(Optional) Map with georeplication locations."
  type = list(object({
    location                  = string
    regional_endpoint_enabled = bool
    zone_redundancy_enabled   = bool
  }))
  default = []
}

variable "kv_name" {
  description = "Name of the key vault"
  type        = string
  default     = "kv-idomingc-tfm"
}
