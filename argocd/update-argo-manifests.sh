#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT="${SCRIPT_DIR}/app/argo-non-crds.yaml"
CRD_KUSTOMIZATION="${SCRIPT_DIR}/crds/kustomization.yaml"

# Extract ArgoCD version from argocd/crds/kustomization.yaml
VERSION=$(grep -oP 'refs/tags/\Kv[\d.]+' "${CRD_KUSTOMIZATION}" | head -1)

if [[ -z "${VERSION}" ]]; then
    echo "ERROR: Could not determine ArgoCD version from ${CRD_KUSTOMIZATION}" >&2
    exit 1
fi

echo "ArgoCD version: ${VERSION}"

INSTALL_URL="https://raw.githubusercontent.com/argoproj/argo-cd/${VERSION}/manifests/install.yaml"

echo "Downloading manifests from: ${INSTALL_URL}"
echo "Filtering out CustomResourceDefinition resources..."

curl -fsSL "${INSTALL_URL}" | \
    yq eval 'select(.kind != "CustomResourceDefinition")' - > "${OUTPUT}"

echo "Done. Saved to: ${OUTPUT}"
