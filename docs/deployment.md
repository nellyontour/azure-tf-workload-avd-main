# Deployment

This workload is deployed via Azure DevOps using the shared pipeline template.

For detailed deployment steps, prerequisites, and environment configuration see:

- **[Deployment Guide](deploy/deployment.md)** — step-by-step instructions, backend configuration, and environment setup
- **[Deployment Checklist](deploy/checklist.md)** — pre-deploy and post-deploy checklist
- **[Runbooks](runbooks/)** — how-to guides for common operations

## Environments

| Environment | tfvars file | Notes |
|-------------|-------------|-------|
| PoC / Dev | `iac/environments/examples/01-poc.tfvars` | Creates all resources locally |
| Enterprise LZ | `iac/environments/examples/02-enterprise-lz.tfvars` | Uses vending-supplied RG + networking |

## Pipeline

Deployment is triggered via `.azure-pipelines/terraform-cicd.yaml`:

- **Pull Request** → `Plan` only (no apply)
- **Push to main** → `Plan & Apply` (requires manual review gate)
- **Manual trigger** → supports `Plan`, `Plan & Apply`, or `Plan & Destroy`
