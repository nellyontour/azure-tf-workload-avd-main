# ──────────────────────────────────────────────────────────────────────────────
# Workload Resources
# ──────────────────────────────────────────────────────────────────────────────
#
# TODO: Replace this placeholder with your workload-specific Terraform resources.
#
# Example (container registry):
#   module "acr" {
#     source              = "Azure/avm-res-containerregistry-registry/azurerm"
#     version             = "~> 0.4"
#     name                = "${local.default_suffix}-acr"
#     resource_group_name = local.resource_group_name
#     location            = local.resource_group_location
#     tags                = local.tags
#   }
#
# Example (storage account — uses short suffix due to 24-char limit):
#   module "storage" {
#     source              = "Azure/avm-res-storage-storageaccount/azurerm"
#     version             = "~> 0.6"
#     name                = "st${local.default_short_suffix}"
#     resource_group_name = local.resource_group_name
#     location            = local.resource_group_location
#     tags                = local.tags
#   }
# ──────────────────────────────────────────────────────────────────────────────
