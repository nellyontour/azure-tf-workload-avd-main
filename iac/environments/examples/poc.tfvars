# poc.tfvars — PoC / standalone deployment
#
# Suitable for: proof-of-concept, sandbox, or environments without a vending pipeline.
# Creates its own resource group, VNet, subnet, and NSG.
# Resource names are auto-computed from workload_name/env_code/short_location_code.
# e.g. "my-workload-sbx-aue-rg", "my-workload-sbx-aue-vnet"
#
# Usage:
#   terraform init
#   terraform plan  -var-file=environments/examples/poc.tfvars
#   terraform apply -var-file=environments/examples/poc.tfvars

subscription_id     = "00000000-0000-0000-0000-000000000000"
workload_name       = "my-workload"
env_code            = "sbx"
short_location_code = "aue"
location            = "australiaeast"
use_existing_rg     = false

# Create all networking locally
create_virtual_network        = true
virtual_network_address_space = ["10.100.0.0/24"]
subnet_address_space          = ["10.100.0.0/26"]

default_tags = {
  ApplicationName = "my-workload"
  DeployedBy      = "Terraform"
  CostCentre      = "TODO"
  Owner           = "TODO"
}
