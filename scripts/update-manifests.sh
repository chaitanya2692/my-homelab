#!/bin/sh -ex

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

# Initialize install.yaml
echo "${AUTOGENMSG}" > "install.yaml"

local_build(){
    # Build command
    kustomize build "${PWD}/overlays/staging" --enable-helm >> "${PWD}/install.yaml"
    # Code cleanup
    find "$PWD" -maxdepth 3 -type d -name 'charts' -exec rm -rf {} \;
}

ci_build(){
    # Build command
    kustomize build "${PWD}/overlays/production" --enable-helm >> "${PWD}/install.yaml"
}

# Check if running in GitHub Actions
if [ -n "$CI" ]; then
    ci_build "$1"
else
    # If running locally
    local_build "$1"
fi
