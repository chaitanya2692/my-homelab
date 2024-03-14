#!/bin/sh -x

SRCROOT="$( CDPATH='' cd -- "$(dirname "$0")" && pwd -P )"
AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

# docker run -v ${PWD}:${PWD} registry.k8s.io/kustomize/kustomize:v5.0.0 edit fix "${SRCROOT}/overlays/armhf/kustomization.yaml"
# docker run -v ${PWD}:${PWD} registry.k8s.io/kustomize/kustomize:v5.0.0 edit fix "${SRCROOT}/overlays/x86/kustomization.yaml"

echo "${AUTOGENMSG}" > "${SRCROOT}/install_x86_64.yaml"
docker run -v ${PWD}:${PWD} registry.k8s.io/kustomize/kustomize:v5.0.0 build "${SRCROOT}/overlays/x86" >> "${SRCROOT}/install_x86_64.yaml"

echo "${AUTOGENMSG}" > "${SRCROOT}/install_armhf.yaml"
docker run -v ${PWD}:${PWD} registry.k8s.io/kustomize/kustomize:v5.0.0 build "${SRCROOT}/overlays/armhf" >> "${SRCROOT}/install_armhf.yaml"
