#!/usr/bin/env bash
set -euo pipefail

###########################################
# Seal Secrets Script
# Seal all plaintext Kubernetes Secret files in-place using kubeseal.
# Dynamically discovers Secret manifests under the base/ directory.
# Prerequisites:
#   - kubeseal CLI installed
#   - Sealed Secrets controller running in the cluster
#   - kubectl context set to the target cluster
###########################################

CONTROLLER_NAME="${SEALED_SECRETS_CONTROLLER_NAME:-sealed-secrets-controller}"
CONTROLLER_NAMESPACE="${SEALED_SECRETS_CONTROLLER_NAMESPACE:-infra}"
SCOPE="cluster-wide"

# Verify kubeseal is installed
if ! command -v kubeseal &>/dev/null; then
    echo "ERROR: kubeseal is not installed. Install it with: brew install kubeseal"
    exit 1
fi

# Dynamically find all Kubernetes Secret files under base/
mapfile -t SECRET_FILES < <(grep -rl "kind: Secret" "base/" --include="*.yaml" | sort)

if [[ ${#SECRET_FILES[@]} -eq 0 ]]; then
    echo "No Secret files found under base/. Nothing to seal."
    exit 0
fi

echo "Sealing secrets in-place with scope: ${SCOPE}"
echo "Controller: ${CONTROLLER_NAME} in namespace: ${CONTROLLER_NAMESPACE}"
echo "Found ${#SECRET_FILES[@]} secret file(s)"
echo "---"

for full_path in "${SECRET_FILES[@]}"; do
    echo "Sealing: ${full_path}"

    if kubeseal \
        --controller-name="${CONTROLLER_NAME}" \
        --controller-namespace="${CONTROLLER_NAMESPACE}" \
        --scope "${SCOPE}" \
        --format yaml \
        < "${full_path}" > "${full_path}.sealed"; then
        mv "${full_path}.sealed" "${full_path}"
        echo "  -> sealed in-place"
    else
        rm -f "${full_path}.sealed"
        echo "  ERROR: Failed to seal ${full_path}"
        exit 1
    fi
done
