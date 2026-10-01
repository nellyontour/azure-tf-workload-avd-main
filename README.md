# workload-iac-terraform

GitHub template for Azure Terraform workloads. Supports both standalone PoC (creates its own RG + networking) and enterprise landing zone (uses vending-supplied resources).

## Quick start

**1. Use the template**

 **Create a new repository**, then clone it.

**2. Reset release-please**

```bash
pwsh helpers/Reset-ReleasePlease.ps1
```

This clears the CHANGELOG and resets the version to `0.0.0`. Follow the prompts it prints.

**3. Create your environment tfvars**

```bash
cp iac/environments/examples/default.tfvars iac/environments/prod.tfvars
# Edit: subscription_id, workload_name, vending resource IDs
# or use poc.tfvars for a standalone environment
```

**4. Wire up CI/CD**

Use [applz-subvending](https://github.com/Datacom-Public-Cloud-IaC/applz-subvending) to create the repository, deployment identities, and CI configuration — it provisions secrets/variables automatically.

**GitHub Actions** (`.github/workflows/deploy.yml`):
- `workflow_dispatch` → select `plan`, `apply`, or `destroy` + target environment
- Uses the [centralised GHA templates](https://github.com/Datacom-Public-Cloud-IaC/azure-iac-gha-templates) (OIDC, plan/apply split, artifact caching)
- Requires GitHub Environments: `{env}_plan` (read-only) and `{env}_apply` (write + required reviewers)

**Azure DevOps** (`.azure-pipelines/terraform-cicd.yaml`):
- Uses centralised ADO pipeline templates with Library variable groups
- Set `ENVIRONMENT_NAME`, `VAR_FILE`, `TERRAFORM_DIRECTORY`, service connections, and `BACKEND_CONFIG_*`

**5. Add your resources**

Edit `iac/main.tf`. Use `local.resource_group_name`, `local.resource_group_location`, `local.subnet_id`, etc.  
Add workload-specific resource names to `locals.naming.tf` following the existing pattern.

---

## Deployment modes

Resources can be created locally (PoC) or consumed from subscription vending (enterprise LZ):

| | PoC / standalone | Enterprise LZ |
|--|------------------|---------------|
| **Resource group** | `use_existing_rg = false` | `use_existing_rg = true` |
| **Networking** | `create_virtual_network = true` | `create_virtual_network = false` + supply vending resource IDs |
| **Example tfvars** | `environments/examples/poc.tfvars` | `environments/examples/default.tfvars` |

NSG baseline rules apply in both modes: VNet        LB        Internet inbound inbound  inbound  

---

## Features

- **Single unified ADO  PR = plan only; merge to `main` = applypipeline** 
- **GitHub Actions  [centralised deploy + PR validation templates](https://github.com/Datacom-Public-Cloud-IaC/azure-iac-gha-templates)workflows** 
- **BYO or  RG and networking are independently switchablecreate** 
- **AVM networking  VNet, subnet, NSG via [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/)modules** 
- **Governance- dotfiles managed by `azure-tf-governance` via dcrsync (tflint, terraform-docs, pre-commit, gitignore, VS Code)aligned** 
- **Security  Checkov + pre-commit hooksscanning** 
- **Release  release-please (`terraform-module` type)management** 

---

## Governance

This repo follows requirements set down in [azure-tf-governance](https://github.com/Datacom-Public-Cloud-IaC/azure-tf-governance).
