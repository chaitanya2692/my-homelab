#!/bin/sh -ex

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

echo "${AUTOGENMSG}" > "install.yaml"

local_build(){
    docker run -v ${PWD}:${PWD} registry.k8s.io/kustomize/kustomize:v5.0.0 build "${PWD}/overlays" >> "${PWD}/install.yaml"
}

ci_build(){
    kustomize build "${PWD}/overlays" >> "${PWD}/install.yaml"
}

# Check if running in GitHub Actions
if [ -n "$CI" ]; then
    ci_build "$1"
else
    # If running locally
    local_build "$1"
fi
