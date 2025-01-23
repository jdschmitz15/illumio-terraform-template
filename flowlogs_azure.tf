
resource "azurerm_network_watcher" "NetWatcher" {
  name                = "NetworkWatcher_${var.azure_location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # lifecycle {

  #   ignore_changes = [ name, location ]

  # }
}

resource "random_string" "random" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}
resource "azurerm_storage_account" "flowlogs" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = random_string.random.id

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
}