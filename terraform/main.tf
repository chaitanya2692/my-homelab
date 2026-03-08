module "platform_bootstrap" {
  source = "./modules/platform-bootstrap"
}

module "vault_bootstrap" {
  source = "./modules/vault-bootstrap"

  kubernetes_host      = var.kubernetes_host
  kubernetes_ca_cert   = var.kubernetes_ca_cert
  vault_token_reviewer_jwt = var.vault_token_reviewer_jwt

  depends_on = [module.platform_bootstrap]
}
