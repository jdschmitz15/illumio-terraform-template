terraform {
  required_version = ">=0.12"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "testdrive"
  location = var.azure_location

  tags = {
    environment = "Production"
  }
}
variable "azure_location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "azure_vnetA_cidr" {
  description = "Azure VNet1 CIDR"
  type        = string
  default     = "192.168.1.0/24"
}

variable "azure_vnetB_cidr" {
  description = "Azure VNet2 CIDR"
  type        = string
  default     = "192.168.2.0/24"
}