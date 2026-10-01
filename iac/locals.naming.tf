locals {
  # Default Convention: workload-env-location-type
  # e.g. "my-workload-dev-aue-rg"
  #
  # When creating a workload repo from this template, you can pin workload_name
  # as a constant here rather than keeping it as a variable:
  #   workload_name = "my-specific-workload"

  workload_name = var.workload_name

  # Short name (no hyphens) for length-constrained resources.
  # Storage accounts: 24 chars total (e.g. "st" + 16 chars + env)
  short_workload_name = substr(replace(local.workload_name, "-", ""), 0, 16)

  # Standard suffix: <workload>-<env>-<location>
  default_suffix = "${local.workload_name}-${var.env_code}-${var.short_location_code}"

  # Short suffix for resources with strict name length limits (no hyphens, lowercase)
  # tflint-ignore: terraform_unused_declarations
  default_short_suffix = lower("${local.short_workload_name}${var.env_code}")

  # 
  # Resource names - use this pattern to allow overrides via variables.
  # 
  resource_group_name         = coalesce(var.resource_group_name, "${local.default_suffix}-rg")
  virtual_network_name        = coalesce(var.virtual_network_name, "${local.default_suffix}-vnet")
  subnet_name                 = coalesce(var.subnet_name, "${local.default_suffix}-sn")
  network_security_group_name = coalesce(var.network_security_group_name, "${local.default_suffix}-nsg")
  # examples:
  # storage_account_name        = coalesce(var.storage_account_name, "${local.default_short_suffix}st")
  # key_vault_name              = coalesce(var.key_vault_name, "${local.default_suffix}-kv")
}
