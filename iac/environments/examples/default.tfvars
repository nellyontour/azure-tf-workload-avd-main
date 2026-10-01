# Default - Enterprise Landing Zone deployment
#
# Uses resource group, VNet, and subnet supplied by subscription vending.
#
# Usage:
#   terraform init
#   terraform plan  -var-file=environments/examples/default.tfvars
#   terraform apply -var-file=environments/examples/default.tfvars

subscription_id     = "00000000-0000-0000-0000-000000000000"
workload_name       = "my-workload"
env_code            = "prod"
short_location_code = "aue"
location            = "australiaeast"
use_existing_rg     = true

# Override naming conventions in locals.naming.tf if preferred

# Supply resource IDs from vending
create_virtual_network = false
virtual_network_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-workload-prod-aue-rg/providers/Microsoft.Network/virtualNetworks/my-workload-prod-aue-vnet"
existing_subnet_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-workload-prod-aue-rg/providers/Microsoft.Network/virtualNetworks/my-workload-prod-aue-vnet/subnets/my-workload-prod-aue-sn"

# Optional: supply existing NSG (from vending) or let this module create one alongside the subnet
# existing_network_security_group_id = "/subscriptions/.../resourceGroups/my-workload-prod-aue-rg/providers/Microsoft.Network/networkSecurityGroups/my-workload-prod-aue-nsg"

default_tags = {
  ApplicationName = "my-workload"
  DeployedBy      = "Terraform"
  CostCentre      = "TODO"
  Owner           = "TODO"
}
