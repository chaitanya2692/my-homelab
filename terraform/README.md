# Terraform bootstrap

This stack bootstraps foundational homelab components declaratively:

- Kubernetes namespaces (`infra`, `utils`, `htpc`, `argocd`)
- Argo CD (Helm)
- HashiCorp Vault (Helm)
- Vault Secrets Operator (Helm)
- Argo CD ingress + ServiceMonitors + ApplicationSet
- Vault KV v2 mount, namespace-scoped policies, and Kubernetes auth roles

## Usage

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Required follow-up

1. Initialize and unseal Vault once.
2. Export `VAULT_TOKEN` for Terraform Vault provider.
3. Fill `kubernetes_ca_cert` and `vault_token_reviewer_jwt` in `terraform.tfvars`.
4. Re-run `terraform apply` to complete Vault Kubernetes auth role/policy provisioning.
