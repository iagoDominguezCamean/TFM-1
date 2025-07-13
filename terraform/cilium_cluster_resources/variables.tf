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
variable "cilium_config" {
  description = "Options to customize cilium"
  type = object({
    pod_cidr_list                                  = optional(string, "10.10.0.0/22")
    hubble_relay_enabled                           = optional(string, "true")
    hubble_relay_prometheus_enabled                = optional(string, "false")
    hubble_relay_prometheus_serviceMonitor_enabled = optional(string, "false")
    hubble_enabled                                 = optional(string, "true")
    hubble_ui_enabled                              = optional(string, "true")
    hubble_metrics_enabled                         = optional(string, "{dns,drop,tcp,flow,port-distribution,icmp,http}")
    hubble_metrics_enableOpenMetrics               = optional(string, "false")
    hubble_metrics_serviceMonitor_enabled          = optional(string, "false")
    prometheus_enabled                             = optional(string, "false")
    prometheus_serviceMonitor_enabled              = optional(string, "false")
    operator_prometheus_enabled                    = optional(string, "false")
    operator_prometheus_serviceMonitor_enabled     = optional(string, "false")
  })
  default = {}
}
