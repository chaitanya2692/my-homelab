locals {
  namespaces = toset(["argocd", "infra", "utils", "htpc"])
}

resource "kubernetes_namespace" "namespaces" {
  for_each = local.namespaces

  metadata {
    name = each.key
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = kubernetes_namespace.namespaces["argocd"].metadata[0].name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.2"
  create_namespace = false

  values = [file("${path.module}/values/argocd-values.yaml")]
}

resource "helm_release" "vault" {
  name             = "vault"
  namespace        = kubernetes_namespace.namespaces["infra"].metadata[0].name
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = "0.30.1"
  create_namespace = false

  values = [file("${path.module}/values/vault-values.yaml")]
}

resource "helm_release" "vault_secrets_operator" {
  name             = "vault-secrets-operator"
  namespace        = kubernetes_namespace.namespaces["infra"].metadata[0].name
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  version          = "0.10.0"
  create_namespace = false

  values = [file("${path.module}/values/vso-values.yaml")]

  depends_on = [helm_release.vault]
}

resource "kubernetes_manifest" "argocd_ingress_route" {
  count = var.enable_argocd_custom_resources ? 1 : 0

  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "ingressroute"
      namespace = "argocd"
      annotations = {
        "kubernetes.io/ingress.class" = "traefik-external"
      }
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`argocd.my-homelab.party`)"
          kind  = "Rule"
          services = [
            {
              name = "argocd-server"
              port = 443
            }
          ]
        }
      ]
    }
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "argocd_service_monitor_metrics" {
  count = var.enable_argocd_custom_resources ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-metrics"
      namespace = "argocd"
      labels = {
        release = "kube-prometheus-stack"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-metrics"
        }
      }
      endpoints = [{ port = "metrics" }]
    }
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "argocd_service_monitor_server" {
  count = var.enable_argocd_custom_resources ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-server-metrics"
      namespace = "argocd"
      labels = {
        release = "kube-prometheus-stack"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-server-metrics"
        }
      }
      endpoints = [{ port = "metrics" }]
    }
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "argocd_service_monitor_repo" {
  count = var.enable_argocd_custom_resources ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-repo-server-metrics"
      namespace = "argocd"
      labels = {
        release = "kube-prometheus-stack"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "argocd-repo-server"
        }
      }
      endpoints = [{ port = "metrics" }]
    }
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "argocd_homelab_applicationset" {
  manifest = yamldecode(file("${path.module}/../../../argocd/app/application.yaml"))

  depends_on = [helm_release.argocd, helm_release.vault_secrets_operator]
}
