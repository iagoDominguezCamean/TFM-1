resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  location                      = var.location
  name                          = var.name
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.sku == "Premium" ? var.zone_redundancy_enabled : false
  tags                          = var.tags

  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                  = each.value.location
      regional_endpoint_enabled = each.value.regional_endpoint_enabled
      zone_redundancy_enabled   = each.value.zone_redundancy_enabled
      tags                      = var.tags
    }
  }
}

resource "azurerm_key_vault" "kv" {
  name                      = var.kv_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "kv_roles" {
  for_each = toset(["Key Vault Secrets Officer", "Key Vault Crypto Officer", "Key Vault Certificates Officer"])

  scope                = azurerm_key_vault.kv.id
  role_definition_name = each.value
  principal_id         = data.azurerm_client_config.current.object_id
}
