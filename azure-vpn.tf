# Azure Resources
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnetA.name
  address_prefixes     = [cidrsubnet(var.azure_vnetA_cidr, 3, 1)]

   depends_on = [ azurerm_subnet.subnetA ]
}

resource "azurerm_public_ip" "vpn_pip" {
  name                = "vpn-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku         = "Standard"
}



resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "azure-vpn-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  type               = "Vpn"
  vpn_type           = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1AZ"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id         = azurerm_public_ip.vpn_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_virtual_network.vnetA.id}/subnets/GatewaySubnet"
  }

  depends_on = [ azurerm_local_network_gateway.aws_lng,azurerm_subnet.GatewaySubnet ]
}

resource "azurerm_local_network_gateway" "aws_lng" {
  name                = "aws-local-network-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  gateway_address     = aws_vpn_connection.vpn.tunnel1_address
  address_space       = [var.aws_vpc1_cidr,var.aws_vpc2_cidr]
}

resource "azurerm_virtual_network_gateway_connection" "azure_to_aws" {
  name                       = "azure-to-aws"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.aws_lng.id
  shared_key                 = var.vpn_shared_key

  depends_on = [ azurerm_local_network_gateway.aws_lng,azurerm_virtual_network_gateway.vpn_gateway ]
}

# resource "azurerm_network_security_group" "vpn" {
#   name                = "vpn-security-group"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "AllowVPNTraffic"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range         = "*"
#     destination_port_range    = "*"
#     source_address_prefix     = var.aws_vpc1_cidr
#     destination_address_prefix = var.azure_vnetA_cidr
#   }
# }

output "azure_public_ip_vpn_ip" {
  value = azurerm_public_ip.vpn_pip.ip_address
}