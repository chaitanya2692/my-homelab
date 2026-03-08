#!/usr/bin/env bash
set -euo pipefail

###########################################
# Kickstart Script
# Bootstraps a cluster with:
# 1. ArgoCD CRDs and controllers
# 2. Bitnami Sealed Secrets controller
# 3. Homelab ApplicationSet and all managed apps
###########################################

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

wait_for_rollout() {
  local namespace=$1
  local resource=$2
  echo "Waiting for rollout: ${resource} in namespace ${namespace}"
  kubectl rollout status "${resource}" -n "${namespace}" --timeout=300s
}

wait_for_applications() {
  local timeout_seconds=${1:-900}
  local interval=15
  local elapsed=0

  echo "Waiting for ArgoCD applications to become Synced/Healthy..."
  while [ "${elapsed}" -lt "${timeout_seconds}" ]; do
    if kubectl get applications.argoproj.io -A >/dev/null 2>&1; then
      not_ready=$(kubectl get applications.argoproj.io -A --no-headers 2>/dev/null | awk '$6 != "Synced" || $7 != "Healthy" { count++ } END { print count+0 }')
      total=$(kubectl get applications.argoproj.io -A --no-headers 2>/dev/null | wc -l | tr -d ' ')

      if [ "${total}" -gt 0 ] && [ "${not_ready}" -eq 0 ]; then
        echo "All ${total} applications are Synced/Healthy."
        return 0
      fi

      echo "Applications ready: $((total-not_ready))/${total}. Rechecking in ${interval}s..."
    else
      echo "ArgoCD applications not created yet. Rechecking in ${interval}s..."
    fi

    sleep "${interval}"
    elapsed=$((elapsed + interval))
  done

  echo "Timed out waiting for applications to become Synced/Healthy."
  kubectl get applications.argoproj.io -A || true
  return 1
}

echo "Creating required namespaces..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace kube-system --dry-run=client -o yaml | kubectl apply -f -

echo "Building and applying ArgoCD CRDs..."
kustomize build "${ROOT_DIR}/argocd/crds" --enable-helm > "${ROOT_DIR}/crds.yaml"
kubectl apply -f "${ROOT_DIR}/crds.yaml"

echo "Waiting for key ArgoCD CRDs..."
kubectl wait --for=condition=Established --timeout=120s crd/applications.argoproj.io
kubectl wait --for=condition=Established --timeout=120s crd/applicationsets.argoproj.io

echo "Installing Sealed Secrets controller..."
kubectl apply -f "https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/controller.yaml"
wait_for_rollout kube-system deployment/sealed-secrets-controller

echo "Building and applying ArgoCD app resources..."
kustomize build "${ROOT_DIR}/argocd/app" --enable-helm > "${ROOT_DIR}/install_argocd.yaml"
kubectl apply -n argocd -f "${ROOT_DIR}/install_argocd.yaml"

wait_for_rollout argocd deployment/argocd-application-controller
wait_for_rollout argocd deployment/argocd-repo-server
wait_for_rollout argocd deployment/argocd-server
wait_for_rollout argocd deployment/argocd-applicationset-controller

wait_for_applications

rm -f "${ROOT_DIR}/crds.yaml" "${ROOT_DIR}/install_argocd.yaml"

echo "----------------------------------------------------"
echo "ArgoCD initial admin password:"
kubectl get secrets/argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d
echo ""

echo "Optional local UI access:"
echo "kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443"
