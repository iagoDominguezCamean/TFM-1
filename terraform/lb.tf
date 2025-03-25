resource "azurerm_public_ip" "pub_ip_lb" {
  name                = "pubip-lb-aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb_aks" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "lb-aks"

  frontend_ip_configuration {
    name                 = "PublicIPAddres"
    public_ip_address_id = azurerm_public_ip.pub_ip_lb.id
    zones                = [ "1" ]
  }
}
