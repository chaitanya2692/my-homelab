#!/usr/bin/env bash
set -euo pipefail

###########################################
# Validate Script
# Validates YAML files, Kubernetes manifests,
# kustomize overlays, and Terraform configuration.
###########################################

cd "$(git rev-parse --show-toplevel)"

KUSTOMIZE_FLAGS="--load-restrictor=LoadRestrictionsNone --enable-helm --enable-alpha-plugins --enable-exec"
KUSTOMIZE_CONFIG="kustomization.yaml"
KUBECONFORM_FLAGS="-skip=Secret"
KUBECONFORM_CONFIG="-strict -ignore-missing-schemas -verbose"

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR - Required command '$cmd' is not installed"
    exit 1
  fi
}

require_cmd yq
require_cmd kubeconform
require_cmd kustomize

echo "INFO - Validating YAML files"
find . -type f -name '*.yaml' -print0 | while IFS= read -r -d $'\0' file; do
  echo "INFO - Validating $file"
  yq e 'true' "$file" > /dev/null
done

echo "INFO - Validating Kubernetes manifests"
find . -type f -name '*.yaml' ! -name '*values*.yaml' ! -name '.pre-commit-config.yaml' ! -name '.sops.yaml' ! -name '.markdownlint-cli2.yaml' -print0 | while IFS= read -r -d $'\0' file; do
  kubeconform ${KUBECONFORM_FLAGS} ${KUBECONFORM_CONFIG} "${file}"
done

echo "INFO - Validating kustomize overlays"
find . -type f -name ${KUSTOMIZE_CONFIG} -print0 | while IFS= read -r -d $'\0' file; do
  echo "INFO - Validating kustomization ${file/%$KUSTOMIZE_CONFIG}"
  kustomize build "${file/%$KUSTOMIZE_CONFIG}" ${KUSTOMIZE_FLAGS} | kubeconform ${KUBECONFORM_FLAGS} ${KUBECONFORM_CONFIG}
done

if [ -d terraform ]; then
  require_cmd terraform
  echo "INFO - Validating Terraform"
  terraform -chdir=terraform fmt -check -recursive
  terraform -chdir=terraform init -backend=false
  terraform -chdir=terraform validate
fi
