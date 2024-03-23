#!/bin/sh -x

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided."
    echo "Usage: $0 armhf or $0 x86"
    exit 1
fi

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

echo "${AUTOGENMSG}" > "install_$1.yaml"

local_build(){
    docker run -v ${PWD}:${PWD} registry.k8s.io/kustomize/kustomize:v5.0.0 build "${PWD}/overlays/$1" >> "${PWD}/install_$1.yaml"
}

ci_build(){
    kustomize build "${PWD}/overlays/$1" >> "${PWD}/install_$1.yaml"
}

# Check if running in GitHub Actions
if [ -n "$CI" ]; then
    ci_build "$1"
else
    # If running locally
    local_build "$1"
fi
