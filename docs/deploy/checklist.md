# Deployment Checklist

Use this before and after each deployment.

---

## Pre-deployment

### Template configuration

- [ ] Workload-specific variables set in your `.tfvars` file
- [ ] `subscription_id` is correct for the target environment
- [ ] Deployment mode  PoC (`use_existing_rg = false`, `create_virtual_network = true`) or Enterprise LZ (supply vending-provided resource IDs)confirmed
- [ ] `default_tags` include all mandatory tags (ApplicationName, CostCentre)

---

## Post-deployment

### Verification

- [ ] Workload-specific resources are operational (add checks here)

### Documentation

- [ ] README reflects current state of the workload
- [ ] `docs/deploy/deployment.md` updated if configuration changed significantly
- [ ] ADR raised for any significant architectural decision
