# How to Upgrade Providers and Modules

This runbook covers upgrading Terraform providers and AVM modules used in this workload.

---

## Upgrading providers

### 1. Check for new versions

```bash
cd iac
terraform init -upgrade
```

This fetches the latest versions within the constraints in `terraform.tf`. Review the diff in `.terraform.lock.hcl` (note: this file is git-ignored in this repo by governance policy — see `iac/.gitignore`).

### 2. Update version constraints (if needed)

Edit `iac/terraform.tf` to change the version constraint, then re-run `terraform init -upgrade`.

### 3. Validate

```bash
terraform validate
terraform plan -var-file=environments/examples/default.tfvars
```

---

## Upgrading AVM modules

AVM modules are sourced from the Terraform Registry. Module versions are pinned in `iac/main.network.tf` (and any other module call files).

### 1. Check for updates

Browse the module on the [AVM registry](https://azure.github.io/Azure-Verified-Modules/) or check the GitHub release page for the module.

### 2. Update the version

In the module source block, update the `version` attribute:

```hcl
module "avm_res_network_virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "X.Y.Z"  # updated version
  ...
}
```

### 3. Re-initialise and test

```bash
terraform init -upgrade
terraform validate
terraform plan -var-file=environments/examples/default.tfvars
```

### 4. Review breaking changes

Check the module's CHANGELOG for breaking changes before applying. In particular:
- Renamed variables
- Removed outputs
- Changed resource naming or tagging behaviour

---

## Upgrading the pipeline template

The `.azure-pipelines/terraform-cicd.yaml` file is a governance-managed file synced via `dcrsync`.  
**Do not manually edit it.** Raise a request via the `azure-tf-governance` repository to update the template.

---

## Notes

- Lock files (`.terraform.lock.hcl`) are not committed in this repo (see `iac/.gitignore`)
- If the lock file causes issues in CI, ensure `terraform init` runs without `-upgrade` in normal pipeline runs
