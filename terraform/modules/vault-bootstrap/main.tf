resource "vault_mount" "kv" {
  path        = "kv"
  type        = "kv-v2"
  description = "Homelab static secrets"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "cluster" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = var.kubernetes_host
  kubernetes_ca_cert = var.kubernetes_ca_cert
  token_reviewer_jwt = var.vault_token_reviewer_jwt
}

resource "vault_policy" "infra_read" {
  name   = "infra-read"
  policy = <<EOT
path "kv/data/infra/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "utils_read" {
  name   = "utils-read"
  policy = <<EOT
path "kv/data/utils/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "htpc_read" {
  name   = "htpc-read"
  policy = <<EOT
path "kv/data/htpc/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "infra_vso" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "infra-vso"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["infra"]
  token_policies                   = [vault_policy.infra_read.name]
  token_ttl                        = 3600
}

resource "vault_kubernetes_auth_backend_role" "utils_vso" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "utils-vso"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["utils"]
  token_policies                   = [vault_policy.utils_read.name]
  token_ttl                        = 3600
}

resource "vault_kubernetes_auth_backend_role" "htpc_vso" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "htpc-vso"
  bound_service_account_names      = ["vault-auth"]
  bound_service_account_namespaces = ["htpc"]
  token_policies                   = [vault_policy.htpc_read.name]
  token_ttl                        = 3600
}
