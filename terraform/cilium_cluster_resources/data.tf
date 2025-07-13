data "azurerm_key_vault" "kv" {
  resource_group_name = var.resource_group_name
  name                = "kv-idomingc-tfm"
}
