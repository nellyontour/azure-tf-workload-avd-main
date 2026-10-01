# Deployment Guide

For step-by-step CLI instructions, see [docs/runbooks/how-to-deploy.md](../runbooks/how-to-deploy.md).

---

## Repository and CI setup

Use the [applz-subvending module](https://github.com/Datacom-Public-Cloud-IaC/applz-subvending) to create the repository, CI pipeline, and deployment identities in Azure DevOps or GitHub.  
This process creates the repo, configures the pipeline, and automatically provisions the necessary environment secrets and library variables.

> **TODO:** Add this template into the subvending module as a selectable workload template.

### GitHub Actions

The template includes two workflows:

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| `deploy.yml` | Plan / apply / destroy | `workflow_dispatch` |
| `pr-validation.yml` | Static analysis, optional deep plan | Pull request to `main` |

Both call the [centralised GHA templates](https://github.com/Datacom-Public-Cloud-IaC/azure-iac-gha-templates).

**GitHub Environments required:**

| Environment | Purpose | Protection rules |
|-------------|---------|-----------------|
| `{env}_plan` | Plan operations (read-only OIDC) | None |
| `{env}_apply` | Apply operations (write OIDC) | Required reviewers |

**Environment variables** (set on each environment):

| Variable | Required | Description |
|----------|----------|-------------|
| `AZURE_CLIENT_ID` | ✅ | App registration (client) ID for OIDC |
| `AZURE_SUBSCRIPTION_ID` | ✅ | Target subscription |
| `AZURE_TENANT_ID` | ✅ | Azure AD tenant |
| `TF_STATE_RESOURCE_GROUP` | ✅ | RG containing the state storage account |
| `TF_STATE_BLOB_ACCOUNT` | ✅ | Storage account for Terraform state |
| `TF_STATE_BLOB_CONTAINER` | | State container (default: `tfstate`) |
| `TF_SUBSCRIPTION_ID` | | State storage subscription (defaults to `AZURE_SUBSCRIPTION_ID`) |

**OIDC federated credentials** — create in Azure AD for each environment's service principal:

```
Issuer:    https://token.actions.githubusercontent.com
Subject:   repo:<org>/<repo>:environment:<environment_name>
Audience:  api://AzureADTokenExchange
```

### Azure DevOps

The ADO pipeline (`.azure-pipelines/terraform-cicd.yaml`) calls centralised pipeline templates via Library variable groups.  
Set `ENVIRONMENT_NAME`, `VAR_FILE`, `TERRAFORM_DIRECTORY`, service connections, and `BACKEND_CONFIG_*` in the Library group.

---

## Template configuration

After cloning this template:

1. Set `workload_name` in your `.tfvars`  this drives all auto-computed resource names via `locals.naming.tf`.file
2. Add workload-specific resources to `iac/main.tf`, referencing `local.resource_group_name`, `local.resource_group_location`, `local.subnet_id`, etc.
3. Extend `locals.naming.tf` with resource-specific names following the same pattern:

   ```hcl
   storage_account_name = coalesce(var.storage_account_name, "${local.default_short_suffix}st")
   key_vault_name       = coalesce(var.key_vault_name, "${local.default_suffix}-kv")
   ```

4. Update `iac/backend.tf` with your state storage account details.

---

## Naming convention

This workload follows the Datacom naming  resource type goes **at the end**:convention

```
<workload>-<env>-<location>-<type>
```

Examples: `my-workload-prod-aue-rg`, `my-workload-prod-aue-vnet`, `my-workload-prod-aue-sn`

Set `workload_name` in your `.tfvars` and let `locals.naming.tf` compute the rest. Override individual names via variables when a resource was created externally (e.g. by subscription vending).

---

## Deployment modes

### PoC / standalone

Use `iac/environments/examples/poc.tfvars` as a starting point.  
Creates its own resource group, VNet, subnet, and  no vending required.NSG

```bash
cp iac/environments/examples/poc.tfvars iac/environments/sbx.tfvars
# Edit with real subscription ID
terraform init
terraform plan -var-file=environments/sbx.tfvars
```

### Enterprise Landing Zone

Use `iac/environments/examples/default.tfvars` as a starting point.  
Assumes resource group, VNet, and subnet were provisioned by subscription vending.

```bash
cp iac/environments/examples/default.tfvars iac/environments/prod.tfvars
# Edit with real resource IDs from vending output
terraform init
terraform plan -var-file=environments/prod.tfvars
```
