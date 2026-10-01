locals {
  #
  # Resolved subscription ID
  # Prefer the explicit variable; fall back to the authenticated context.
  #
  subscription_id = coalesce(var.subscription_id, data.azapi_client_config.current.subscription_id)

  #
  # Resolved resource group location
  # Reference the actual resource or data source so Terraform builds the
  # correct dependency graph (things deployed into the RG depend on this local).
  #
  resource_group_location = var.use_existing_rg ? data.azurerm_resource_group.existing[0].location : azurerm_resource_group.this[0].location

  #
  # Resolved network resource IDs
  # Prefer existing IDs supplied via variable; fall back to the AVM module output.
  #
  virtual_network_id = var.create_virtual_network ? module.avm_res_network_vnet[0].resource_id : var.virtual_network_id
  nsg_id             = var.existing_network_security_group_id != null ? var.existing_network_security_group_id : (length(module.avm_res_network_nsg) > 0 ? module.avm_res_network_nsg[0].resource_id : null)
  # tflint-ignore: terraform_unused_declarations
  subnet_id = var.existing_subnet_id != null ? var.existing_subnet_id : (length(module.avm_res_network_subnet) > 0 ? module.avm_res_network_subnet[0].resource_id : null)

  #
  # Tags
  #
  tags = merge(
    var.default_tags,
    {
      Environment  = var.env_code
      LocationCode = var.short_location_code
    }
  )
}
