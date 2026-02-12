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
}

resource "azurerm_key_vault_secret" "grafana_admin_passwd" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "kubenet-grafana-admin-passwd"
  value        = random_password.grafana_password.result
}

resource "azurerm_key_vault_secret" "grafana_admin_username" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "kubenet-grafana-admin-username"
  value        = random_string.grafana_adminuser.result
}
