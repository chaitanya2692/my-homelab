#!/usr/bin/env bash
set -euo pipefail

###########################################
# Seal Secrets Script
# Converts plain Kubernetes Secret manifests into SealedSecrets.
#
# Usage:
#   ./scripts/seal-secrets.sh [path]
#
# Convention:
#   Input file:  *.secret.yaml
#   Output file: sealed-secret.yaml (same directory)
###########################################

TARGET_PATH=${1:-$(git rev-parse --show-toplevel)/base}
SEALED_SECRETS_CONTROLLER_NAMESPACE=${SEALED_SECRETS_CONTROLLER_NAMESPACE:-kube-system}
SEALED_SECRETS_CONTROLLER_NAME=${SEALED_SECRETS_CONTROLLER_NAME:-sealed-secrets-controller}

if ! command -v kubeseal >/dev/null 2>&1; then
  echo "Error: kubeseal is required but not installed."
  exit 1
fi

sealed_count=0
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  output_file="${dir}/sealed-secret.yaml"

  echo "Sealing ${file} -> ${output_file}"
  kubeseal \
    --controller-namespace "${SEALED_SECRETS_CONTROLLER_NAMESPACE}" \
    --controller-name "${SEALED_SECRETS_CONTROLLER_NAME}" \
    --format yaml < "$file" > "$output_file"

  sealed_count=$((sealed_count + 1))
done < <(find "${TARGET_PATH}" -type f -name '*.secret.yaml' -print0)

if [ "${sealed_count}" -eq 0 ]; then
  echo "No *.secret.yaml files found under ${TARGET_PATH}."
else
  echo "Sealed ${sealed_count} secret manifest(s)."
fi
