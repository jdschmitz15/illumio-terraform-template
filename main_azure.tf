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
  subscription_id = var.SUBSCRIPTION_ID
  client_id     = var.CLIENT_ID      # Azure AD Application Client ID
  client_secret = var.CLIENT_SECRET  # Azure AD Application Client Secret
  tenant_id     = var.TENANT_ID     # Azure AD Tenant ID
  use_cli       = false
}

resource "azurerm_resource_group" "rg" {
  name     = "testdrive"
  location = "West US"

  tags = {
    environment = "Production"
  }
}

variable "CLIENT_ID" {
  description = "Client ID"
  type        = string
}

variable "CLIENT_SECRET" {
  description = "Client secret"
  type        = string
}

variable "TENANT_ID" {
  description = "Tenant ID"
  type        = string
}

variable "SUBSCRIPTION_ID" {
  description = "Subscription ID"
  type        = string
}
