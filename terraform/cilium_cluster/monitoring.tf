# resource "azurerm_monitor_workspace" "prometheus" {
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   name                = "prometheus"
# }

# resource "azurerm_dashboard_grafana" "grafana" {
#   name                              = "aks-grafana"
#   resource_group_name               = var.resource_group_name
#   location                          = var.location
#   grafana_major_version             = 11
#   api_key_enabled                   = true
#   deterministic_outbound_ip_enabled = true
#   public_network_access_enabled     = true

#   identity {
#     type = "SystemAssigned"
#   }
# }

# # Add required role assignment over resource group containing the Azure Monitor Workspace
# resource "azurerm_role_assignment" "grafana" {
#   scope                = data.azurerm_resource_group.rg.id
#   role_definition_name = "Monitoring Reader"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# # Add role assignment to Grafana so an admin user can log in
# resource "azurerm_role_assignment" "grafana-admin" {
#   scope                = azurerm_dashboard_grafana.grafana.id
#   role_definition_name = "Grafana Admin"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
