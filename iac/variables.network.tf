# ──────────────────────────────────────────────────────────────────────────────
# Virtual Network
# Default: created by vending (supply virtual_network_id)
# Optional: created here when create_virtual_network = true
# ──────────────────────────────────────────────────────────────────────────────

variable "create_virtual_network" {
  description = "When true, creates the virtual network in this module. When false, supply virtual_network_id from vending."
  type        = bool
  default     = false
}

variable "virtual_network_id" {
  description = "The resource ID of a pre-existing virtual network (e.g. created by vending). Required when create_virtual_network is false."
  type        = string
  default     = null

  validation {
    condition     = var.virtual_network_id == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+$", var.virtual_network_id))
    error_message = "virtual_network_id must be a valid Azure Virtual Network resource ID."
  }
}

variable "virtual_network_name" {
  description = "The name of the virtual network. Only used when create_virtual_network is true."
  type        = string
  default     = null
}

variable "virtual_network_address_space" {
  description = "The address space for the virtual network. Only used when create_virtual_network is true."
  type        = list(string)
  default     = []
}

variable "virtual_network_dns_servers" {
  description = "The list of DNS server IP addresses for the virtual network. Only used when create_virtual_network is true."
  type        = list(string)
  default     = []
}

# ──────────────────────────────────────────────────────────────────────────────
# Subnet
# Default: created here with NSG association
# Optional: supply existing_subnet_id to skip local creation
# ──────────────────────────────────────────────────────────────────────────────

variable "existing_subnet_id" {
  description = "The resource ID of a pre-existing subnet (e.g. created by vending). When set, skips local subnet creation."
  type        = string
  default     = null

  validation {
    condition     = var.existing_subnet_id == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.existing_subnet_id))
    error_message = "existing_subnet_id must be a valid Azure Subnet resource ID."
  }
}

variable "subnet_name" {
  description = "The name of the subnet. Only used when existing_subnet_id is null."
  type        = string
  default     = null
}

variable "subnet_address_space" {
  description = "The address prefixes for the subnet. Only used when existing_subnet_id is null."
  type        = list(string)
  default     = []
}

# ──────────────────────────────────────────────────────────────────────────────
# Network Security Group
# Default: created here with baseline deny-inbound-internet rules
# Optional: supply existing_network_security_group_id to skip local creation
# ──────────────────────────────────────────────────────────────────────────────

variable "existing_network_security_group_id" {
  description = "The resource ID of a pre-existing NSG (e.g. created by vending). When set, skips local NSG creation."
  type        = string
  default     = null

  validation {
    condition     = var.existing_network_security_group_id == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/networkSecurityGroups/[^/]+$", var.existing_network_security_group_id))
    error_message = "existing_network_security_group_id must be a valid Azure Network Security Group resource ID."
  }
}

variable "network_security_group_name" {
  description = "The name of the network security group. Only used when existing_network_security_group_id is null."
  type        = string
  default     = null
}
