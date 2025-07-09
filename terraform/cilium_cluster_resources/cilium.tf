resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  # version    = "1.16.2"
  namespace = "kube-system"

  set {
    name  = "aksbyocni.enabled"
    value = "true"
  }
  set {
    name  = "nodeinit.enabled"
    value = "true"
  }
  set {
    name  = "ipam.operator.clusterPoolIPv4PodCIDRList"
    value = var.pod_cidr_list
  }
  set {
    name  = "hubble.relay.enabled"
    value = var.hubble_relay_enabled
  }
  set {
    name  = "hubble.enabled"
    value = "true"
  }
  set {
    name  = "hubble.metrics.enabled"
    value = "{dns,drop,tcp,flow,port-distribution,icmp,http}"
  }
  set {
    name  = "hubble.metrics.enableOpenMetrics"
    value = "true"
  }
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.port"
    value = "9962"
  }
  set {
    name  = "operator.prometheus.enabled"
    value = "true"
  }
}

resource "random_password" "grafana_password" {
  length = 14
}

# Prometheus and Grafana install
resource "helm_release" "kube-prometheus-stack" {
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  name             = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.adminUser"
    value = "admin"
  }

  set {
    name  = "grafana.adminPassword"
    value = "admin"
  }
}
