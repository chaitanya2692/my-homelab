#!/usr/bin/env bash
set -euo pipefail

###########################################
# Validate Script
# This script validates YAML files and Kubernetes manifests.
# It uses yq for YAML validation and kubeconform for Kubernetes
# manifest validation. It also validates kustomize overlays.
###########################################

# Set the working directory to the root of the git repository
cd "$(git rev-parse --show-toplevel)"

# Set necessary environment variables
KUSTOMIZE_FLAGS="--load-restrictor=LoadRestrictionsNone --enable-helm --enable-alpha-plugins --enable-exec"
KUSTOMIZE_CONFIG="kustomization.yaml"
KUBECONFORM_FLAGS="-skip=Secret"
KUBECONFORM_CONFIG="-strict -ignore-missing-schemas -verbose"

echo "INFO - Validating YAML files"
find . -type f -name '*.yaml' -print0 | while IFS= read -r -d $'\0' file;
do
  echo "INFO - Validating $file"
  yq e 'true' "$file" > /dev/null
done

echo "INFO - Validating Kubernetes manifests"
find . -type f -name '*.yaml' ! -name 'values.yaml' ! -name '.pre-commit-config.yaml' ! -name '.sops.yaml' -print0 | while IFS= read -r -d $'\0' file; do
  kubeconform ${KUBECONFORM_FLAGS} ${KUBECONFORM_CONFIG} "${file}"
done

echo "INFO - Validating kustomize overlays"
find . -type f -name ${KUSTOMIZE_CONFIG} -print0 | while IFS= read -r -d $'\0' file; do
  echo "INFO - Validating kustomization ${file/%$KUSTOMIZE_CONFIG}"
  kustomize build "${file/%$KUSTOMIZE_CONFIG}" ${KUSTOMIZE_FLAGS} | \
    kubeconform ${KUBECONFORM_FLAGS} ${KUBECONFORM_CONFIG}
done

# Code cleanup
find "$PWD" -maxdepth 3 -type d -name 'charts' -exec rm -rf {} \;
