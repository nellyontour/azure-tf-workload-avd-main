terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azapi" {}

provider "azurerm" {
  subscription_id = var.subscription_id

  # Only register providers explicitly used — security best practice
  resource_provider_registrations = "none"

  features {
    resource_group {
      # Handles MCAPS / policy-driven resources that appear in the RG without being in state
      prevent_deletion_if_contains_resources = false
    }

    # Uncomment if this workload uses Key Vault
    # key_vault {
    #   purge_soft_delete_on_destroy    = false
    #   recover_soft_deleted_key_vaults = true
    # }
  }
}
