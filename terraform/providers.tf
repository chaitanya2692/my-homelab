variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "vault_address" {
  description = "Vault service URL reachable from Terraform"
  type        = string
  default     = "http://127.0.0.1:8200"
}

provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kubeconfig_path)
  }
}

provider "vault" {
  address = var.vault_address
}
