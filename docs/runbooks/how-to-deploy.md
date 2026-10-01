# How to Deploy

This runbook covers end-to-end steps for deploying this workload using Terraform.

---

## Prerequisites

- [ ] Azure CLI installed and authenticated (`az login`)
- [ ] Terraform >= 1.9 installed
- [ ] Access to the Azure subscription (at minimum: Contributor on the target resource group, or Owner if creating the resource group)
- [ ] Access to the Terraform state storage account (Storage Blob Data Contributor)
- [ ] A populated `environments/<env>.tfvars` file for your target environment (see `iac/environments/examples/`)

---

## 1. Clone and configure

```bash
git clone <repo-url>
cd <repo>
cp iac/environments/examples/01-poc.tfvars iac/environments/<your-env>.tfvars
# Edit <your-env>.tfvars with your subscription ID, resource group name, etc.
```

---

## 2. Configure the backend

Edit `iac/backend.tf` to point at your state storage account, or pass backend config at init time:

```bash
cd iac
terraform init \
  -backend-config="resource_group_name=rg-tfstate-prod-ae-01" \
  -backend-config="storage_account_name=sttfstateprodae01" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=workload/<workload>.tfstate"
```

---

## 3. Plan

```bash
terraform plan -var-file=environments/<your-env>.tfvars -out=tfplan
```

Review the plan output carefully before proceeding.

---

## 4. Apply

```bash
terraform apply tfplan
```

---

## 5. Verify

- Confirm resources appear in the Azure portal in the expected resource group
- Run any workload-specific smoke tests
- Update the deployment checklist (`docs/deploy/checklist.md`)

---

## Via pipeline (recommended for non-PoC)

Raise a PR against `main`. The pipeline (`terraform-cicd.yaml`) will automatically run `terraform plan`. Once the PR is approved and merged, the pipeline applies the change.

See [docs/deployment.md](../deployment.md) for pipeline details.

---

## Troubleshooting

| Symptom | Resolution |
|---------|------------|
| `Error: Backend configuration changed` | Run `terraform init -reconfigure` |
| `Error: Insufficient privileges` | Check your role assignment on the subscription or resource group |
| `Error: A resource with the ID ... already exists` | Use `terraform import` to bring it under management |
