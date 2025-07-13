cilium_config = {
  hubble_relay_prometheus_enabled                = "true"
  hubble_relay_prometheus_serviceMonitor_enabled = "true"
  hubble_metrics_enableOpenMetrics               = "true"
  hubble_metrics_serviceMonitor_enabled          = "true"
  prometheus_enabled                             = "true"
  prometheus_serviceMonitor_enabled              = "true"
  operator_prometheus_enabled                    = "true"
  operator_prometheus_serviceMonitor_enabled     = "true"
}
