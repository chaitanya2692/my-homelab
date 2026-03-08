variable "enable_argocd_custom_resources" {
  description = "When true, Terraform creates Argo CD IngressRoute and ServiceMonitor CRs after their CRDs already exist in the cluster."
  type        = bool
  default     = false
}
