#!/bin/sh -ex

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

# Initialize install.yaml
echo "${AUTOGENMSG}" > "install.yaml"

# Build command
kustomize build "${PWD}/overlays" --enable-helm >> "${PWD}/install.yaml"

# Code cleanup
find "$PWD" -maxdepth 3 -type d -name 'charts' -exec rm -rf {} \;
