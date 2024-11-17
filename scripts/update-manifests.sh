#!/bin/sh -ex

# Function to check if there are changes in relevant files
check_for_changes() {
    git diff --quiet HEAD -- base overlays scripts
    return $?
}

local_build(){
    # Build command
    kustomize build "${PWD}/overlays/production" --enable-helm --enable-alpha-plugins --enable-exec >> "${PWD}/install.yaml"
    echo "Successfully updated install.yaml"

    # Code cleanup
    find "$PWD" -maxdepth 3 -type d -name 'charts' -exec rm -rf {} \;
}

ci_build(){
    # Build command
    kustomize build "${PWD}/overlays/production" --enable-helm --enable-alpha-plugins --enable-exec >> "${PWD}/install.yaml"
    echo "Successfully updated install.yaml"
}


# Main execution
if check_for_changes; then
    echo "No changes detected in base or overlays. Skipping manifest update."
    exit 0
else
    AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

    # Initialize install.yaml
    echo "${AUTOGENMSG}" > "install.yaml"

    if [ -n "$CI" ]; then
        ci_build "$1"
    else
        local_build "$1"
    fi
    exit $?
fi
