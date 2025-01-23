
# Create virtual network
resource "azurerm_virtual_network" "vnetA" {
  name                = "vnetA"
  address_space       = [var.azure_vnetA_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_virtual_network" "vnetB" {
  name                = "vnetB"
  address_space       = [var.azure_vnetB_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_virtual_network_peering" "peerAtoB" {
  name                      = "peerAtoB"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnetA.name
  remote_virtual_network_id = azurerm_virtual_network.vnetB.id
}
resource "azurerm_virtual_network_peering" "peerBtoA" {
  name                      = "peerBtoA"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnetB.name
  remote_virtual_network_id = azurerm_virtual_network.vnetA.id
}
# Create subnet
resource "azurerm_subnet" "subnetA" {
  name                 = "subnetA"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnetA.name
  address_prefixes     = [cidrsubnet(var.azure_vnetA_cidr, 3, 0)]
}
resource "azurerm_subnet" "subnetB" {
  name                 = "subnetB"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnetB.name
  address_prefixes     = [cidrsubnet(var.azure_vnetB_cidr, 3, 0)]
}


# Create public IPs
resource "azurerm_public_ip" "JumpIP" {
  name                = "JumpIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

