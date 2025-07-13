locals {
  cilium_config = [
    {
      name  = "aksbyocni.enabled"
      value = "true"
    },
    {
      name  = "nodeinit.enabled"
      value = "true"
    },
    {
      name  = "ipam.operator.clusterPoolIPv4PodCIDRList"
      value = var.cilium_config.pod_cidr_list
    },
    {
      name  = "hubble.relay.enabled"
      value = var.cilium_config.hubble_relay_enabled
    },
    {
      name  = "hubble.relay.prometheus.enabled"
      value = var.cilium_config.hubble_relay_prometheus_enabled
    },
    {
      name  = "hubble.relay.prometheus.serviceMonitor.enabled"
      value = var.cilium_config.hubble_relay_prometheus_serviceMonitor_enabled
    },
    {
      name  = "hubble.enabled"
      value = var.cilium_config.hubble_enabled
    },
    {
      name  = "hubble.metrics.enabled"
      value = var.cilium_config.hubble_metrics_enabled
    },
    {
      name  = "hubble.metrics.enableOpenMetrics"
      value = var.cilium_config.hubble_metrics_enableOpenMetrics
    },
    {
      name  = "hubble.metrics.serviceMonitor.enabled"
      value = var.cilium_config.hubble_metrics_serviceMonitor_enabled
    },
    {
      name  = "prometheus.enabled"
      value = var.cilium_config.prometheus_enabled
    },
    {
      name  = "prometheus.serviceMonitor.enabled"
      value = var.cilium_config.prometheus_serviceMonitor_enabled
    },
    {
      name  = "operator.prometheus.enabled"
      value = var.cilium_config.operator_prometheus_enabled
    },
    {
      name  = "operator.prometheus.serviceMonitor.enabled"
      value = var.cilium_config.operator_prometheus_serviceMonitor_enabled
    },
    {
      name  = "hubble.ui.enabled"
      value = var.cilium_config.hubble_ui_enabled
    },
  ]
}
