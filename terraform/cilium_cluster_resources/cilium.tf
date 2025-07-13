resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  # version    = "1.16.2"
  namespace = "kube-system"

  dynamic "set" {
    for_each = local.cilium_config

    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}

resource "random_password" "grafana_password" {
  length = 14
}

resource "random_string" "grafana_adminuser" {
  length  = 14
  special = false
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
    value = random_string.grafana_adminuser.result
  }

  set {
    name  = "grafana.adminPassword"
    value = random_password.grafana_password.result
  }

  depends_on = [helm_release.cilium]
}

resource "azurerm_key_vault_secret" "grafana_admin_passwd" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "grafana-admin-passwd"
  value        = random_password.grafana_password.result
}

resource "azurerm_key_vault_secret" "grafana_admin_username" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "grafana-admin-username"
  value        = random_string.grafana_adminuser.result
}
