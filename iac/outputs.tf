output "resource_group_id" {
  description = "The resource ID of the resource group."
  value       = var.use_existing_rg ? data.azurerm_resource_group.existing[0].id : azurerm_resource_group.this[0].id
}
