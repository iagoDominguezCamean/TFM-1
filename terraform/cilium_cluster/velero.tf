resource "azurerm_storage_account" "sa_velero" {
  count = var.enable_velero ? 1 : 0

  name                     = local.sa_velero
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_replication_type = var.sa_velero_replication_type
  account_tier             = var.sa_velero_tier
}

resource "azurerm_storage_container" "container_velero" {
  count = var.enable_velero ? 1 : 0

  name                  = "velero"
  storage_account_id    = azurerm_storage_account.sa_velero[0].id
  container_access_type = "private"

  depends_on = [azurerm_storage_account.sa_velero]
}
