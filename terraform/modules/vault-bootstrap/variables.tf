variable "kubernetes_host" {
  description = "Kubernetes API host used by Vault Kubernetes auth"
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "kubernetes_ca_cert" {
  description = "Kubernetes CA cert PEM used by Vault Kubernetes auth"
  type        = string
  sensitive   = true
  default     = ""
}

variable "vault_token_reviewer_jwt" {
  description = "JWT for Vault Kubernetes auth token review"
  type        = string
  sensitive   = true
  default     = ""
}
