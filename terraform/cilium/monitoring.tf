# resource "azurerm_dashboard_grafana" "grafana" {
#   name                  = "aks-grafana"
#   resource_group_name   = var.resource_group_name
#   location              = var.location
#   grafana_major_version = 11
#   api_key_enabled       = true
#   deterministic_outbound_ip_enabled = true
#   public_network_access_enabled     = true

#   identity {
#     type = "SystemAssigned"
#   }
# }