#!/bin/sh -ex

###########################################
# Delete Deployment Script
# This script deletes the Kubernetes deployment for the specified
# environment. It removes CRDs, namespaces, and other resources.
# It also cleans up temporary files created during the process.
###########################################

# Default to staging if no environment is specified
ENVIRONMENT=${1:-staging}

check_existing_manifest() {
    if [ -f "install.yaml" ]; then
        echo "Found existing install.yaml, skipping build..."
        return 0
    fi
    return 1
}

update_environment() {
    local env=$1
    for app in htpc utils infra argocd; do
        sed -i "s|components/.*|components/${env}  # Change to ${env} for ${env} environment|" "${PWD}/overlays/${app}/kustomization.yaml"
    done
}

build() {
    AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"
    echo "${AUTOGENMSG}" > "install.yaml"

    # Update environment in kustomization files
    update_environment "${ENVIRONMENT}"

    # Build each overlay separately
    for app in htpc utils infra argocd; do
        echo "---" >> "${PWD}/install.yaml"
        kustomize build "${PWD}/overlays/${app}" --enable-helm --enable-alpha-plugins --enable-exec >> "${PWD}/install.yaml"
    done
}

separate_crds() {
    # Start with the auto-generated message for each file
    echo "${AUTOGENMSG}" > "crds.yaml"
    echo "${AUTOGENMSG}" > "non-crds.yaml"

    # Extract CRDs and preserve indentation
    awk '/^apiVersion: apiextensions.k8s.io\/v1/ && !inside {inside = 1} /^---/ && inside {print "---"; inside = 0; next} inside {print}' install.yaml >> crds.yaml

    # Extract non-CRDs and preserve indentation
    awk '/^apiVersion: apiextensions.k8s.io\/v1/ {inside = 1} /^---/ && inside {inside = 0; next} !inside {print}' install.yaml >> non-crds.yaml
}

cleanup() {
    rm -f crds.yaml non-crds.yaml install.yaml
    find "$PWD" -maxdepth 4 -type d -name 'charts' -exec rm -rf {} \;
}

echo "Building manifests for ${ENVIRONMENT} environment..."
check_existing_manifest || build
separate_crds

echo "----------------------------------------------"
echo "Deleting non-CRD resources..."
kubectl delete -f non-crds.yaml || echo "Non-CRD resources may have already been deleted."

echo "----------------------------------------------"
echo "Deleting namespaces..."
kubectl delete namespace argocd htpc utils || echo "Namespaces may have already been deleted."

echo "----------------------------------------------"
echo "Deleting CRDs..."
kubectl delete -f crds.yaml || echo "CRDs may have already been deleted."

echo "----------------------------------------------"
echo "Cleaning up temporary files..."
cleanup

echo "----------------------------------------------"
echo "All resources have been deleted."
