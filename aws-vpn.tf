# Provider configuration
# Variables
variable "vpn_shared_key" {
  description = "Shared key for VPN connection"
  sensitive   = true
  default = "Illumio123"
}

# AWS Resources

resource "aws_subnet" "vpn" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = cidrsubnet(var.aws_vpc1_cidr, 8, 4)

  tags = {
    Name = "vpn-subnet"
  }
}

resource "aws_customer_gateway" "vpn" {
  bgp_asn    = 65000
  ip_address = azurerm_public_ip.vpn_pip.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "azure-customer-gateway"
  }

  depends_on = [azurerm_public_ip.vpn_pip]
}

resource "aws_vpn_gateway" "vpn" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "aws-vpn-gateway"
  }
  
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn.id
    customer_gateway_id = aws_customer_gateway.vpn.id
    type               = "ipsec.1"
  static_routes_only = true
  tunnel1_preshared_key = var.vpn_shared_key

  tags = {
    Name = "azure-vpn-connection"
  }
  //depends_on = [aws_vpn_gateway.vpn,aws_customer_gateway.vpn]
}

resource "aws_vpn_connection_route" "azure_VNetA" {
  destination_cidr_block = var.azure_vnetA_cidr
  vpn_connection_id      = aws_vpn_connection.vpn.id
}
resource "aws_vpn_connection_route" "azure_VNetB" {
  destination_cidr_block = var.azure_vnetB_cidr
  vpn_connection_id      = aws_vpn_connection.vpn.id
}

# Route Tables
# Create a Route for Internet Gateway To VNETA & VENTB
# resource "aws_route" "azure_routeA" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = var.azure_vnetA_cidr
#   gateway_id             = aws_vpn_gateway.vpn.id
# }
# resource "aws_route" "azure_routeB" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = var.azure_vnetB_cidr
#   gateway_id             = aws_vpn_gateway.vpn.id
# }

resource "aws_vpn_gateway_route_propagation" "example" {
  vpn_gateway_id = aws_vpn_gateway.vpn.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "vpn" {
  subnet_id      = aws_subnet.vpn.id
  route_table_id = aws_route_table.public_rt.id
  
}

# Security Groups
resource "aws_security_group" "vpn" {
  name        = "vpn-security-group"
  description = "Allow traffic from Azure VNet"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.azure_vnetA_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-security-group"
  }
}

# Outputs
output "aws_vpn_connection_id" {
  value = aws_vpn_connection.vpn.id
}
output "aws_vpn_connection_tunnel1_address" {
  value = aws_vpn_connection.vpn.tunnel1_address
}

output "aws_vpn_connection_tunnel2_address" {
  value = aws_vpn_connection.vpn.tunnel2_address
}
