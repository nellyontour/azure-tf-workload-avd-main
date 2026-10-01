data "azapi_client_config" "current" {}

# Use existing resource group (e.g. from subscription vending)
data "azurerm_resource_group" "existing" {
  count = var.use_existing_rg ? 1 : 0
  name  = local.resource_group_name
}

# Create resource group when not using an existing one
resource "azurerm_resource_group" "this" {
  count    = var.use_existing_rg ? 0 : 1
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}
