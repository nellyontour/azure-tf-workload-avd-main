# ──────────────────────────────────────────────────────────────────────────────
# Virtual Network (optional — default is vending-created)
# ──────────────────────────────────────────────────────────────────────────────

module "avm_res_network_vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"
  count   = var.create_virtual_network ? 1 : 0

  name          = local.virtual_network_name
  address_space = var.virtual_network_address_space
  location      = local.resource_group_location

  parent_id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}"

  dns_servers = length(var.virtual_network_dns_servers) > 0 ? {
    dns_servers = var.virtual_network_dns_servers
  } : null

  tags = local.tags
}

# ──────────────────────────────────────────────────────────────────────────────
# Network Security Group (default: created here with baseline rules)
# ──────────────────────────────────────────────────────────────────────────────

module "avm_res_network_nsg" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"
  count   = (var.create_virtual_network || var.virtual_network_id != null) && var.existing_network_security_group_id == null ? 1 : 0

  name                = local.network_security_group_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  security_rules = {
    AllowVNetInBound = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "AllowVNetInBound"
      priority                   = 100
      protocol                   = "*"
      description                = "Allow inbound traffic from the virtual network."
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "*"
    }
    AllowAzureLoadBalancerInBound = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "AllowAzureLoadBalancerInBound"
      priority                   = 110
      protocol                   = "*"
      description                = "Allow inbound traffic from Azure Load Balancer."
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
    DenyAllInternetInBound = {
      access                     = "Deny"
      direction                  = "Inbound"
      name                       = "DenyAllInternetInBound"
      priority                   = 4096
      protocol                   = "*"
      description                = "Deny all inbound traffic from the Internet."
      source_address_prefix      = "Internet"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
  }

  tags = local.tags
}

# ──────────────────────────────────────────────────────────────────────────────
# Subnet (default: created here with NSG associated atomically)
# Uses the AVM VNet subnet submodule which handles NSG association inline —
# no separate association resource required, avoiding the policy gap where a
# subnet exists momentarily without an NSG.
# ──────────────────────────────────────────────────────────────────────────────

module "avm_res_network_subnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.17.1"
  count   = (var.create_virtual_network || var.virtual_network_id != null) && var.existing_subnet_id == null ? 1 : 0

  name             = local.subnet_name
  parent_id        = local.virtual_network_id
  address_prefixes = var.subnet_address_space

  network_security_group = {
    id = local.nsg_id
  }
}
