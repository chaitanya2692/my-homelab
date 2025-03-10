#!/bin/sh -ex

# Default to staging if no environment is specified
ENVIRONMENT=${1:-staging}

# Function to check if there are changes in relevant files
check_for_changes() {
    git diff --quiet HEAD -- base overlays scripts
    return $?
}

update_environment() {
    local env=$1
    for app in htpc utils infra; do
        sed -i "s|components/.*|components/${env}  # Change to ${env} for ${env} environment|" "${PWD}/overlays/${app}/kustomization.yaml"
    done
}

build() {
    AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"
    echo "${AUTOGENMSG}" > "install.yaml"

    # Update environment in kustomization files
    update_environment "${ENVIRONMENT}"

    # Build each overlay separately
    for app in htpc utils infra; do
        kustomize build "${PWD}/overlays/${app}" --enable-helm --enable-alpha-plugins --enable-exec >> "${PWD}/install.yaml"
    done

    echo "Successfully updated install.yaml for ${ENVIRONMENT} environment"
    # Code cleanup
    find "$PWD" -maxdepth 4 -type d -name 'charts' -exec rm -rf {} \;
}

# Main execution
if check_for_changes; then
    echo "No changes detected in base or overlays. Skipping manifest update."
    exit 0
else
    build
    exit $?
fi
