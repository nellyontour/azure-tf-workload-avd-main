variable "subscription_id" {
  description = "Target Azure subscription ID. Leave null to resolve from the authenticated context (recommended for OIDC-based CI)."
  type        = string
  default     = null
}

variable "workload_name" {
  description = <<DESCRIPTION
Workload identifier used as the base for all computed resource names.
Use lowercase kebab-case (e.g. "container-registry", "api-platform").

When creating a workload repo from this template, you can also hardcode
this as a local constant in locals.naming.tf for a single-workload repo.
DESCRIPTION
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}[a-z0-9]$", var.workload_name))
    error_message = "workload_name must be lowercase kebab-case, 3–32 characters."
  }
}

variable "env_code" {
  description = "Short environment code. Used in resource naming and tagging."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["sbx", "dev", "test", "uat", "prod"], var.env_code)
    error_message = "env_code must be one of: sbx, dev, test, uat, prod."
  }
}

variable "location" {
  description = "Azure region for resource deployment."
  type        = string
  default     = "australiaeast"
}

variable "short_location_code" {
  description = "Short location code for use in resource names (e.g. 'aue' for australiaeast, 'ase' for australiasoutheast)."
  type        = string
  default     = "aue"
}

variable "default_tags" {
  description = <<DESCRIPTION
Tags applied to all resources. Extend per-resource with merge():

  tags = merge(local.tags, { ExtraTag = "value" })

Note: Environment and LocationCode are automatically merged from env_code and short_location_code.
DESCRIPTION
  type        = map(string)
  default     = {}
}

# Leave null to auto-compute the RG name from workload naming locals.
# Set this when the RG was created by subscription vending with a different naming pattern.
variable "resource_group_name" {
  description = "Explicit resource group name override. Leave null to use the name computed from workload_name/env_code/short_location_code."
  type        = string
  default     = null
}

variable "use_existing_rg" {
  description = "When true, use an existing resource group (e.g. from subscription vending). When false, create it."
  type        = bool
  default     = true
}
