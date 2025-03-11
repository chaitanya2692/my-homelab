#!/bin/sh -ex

###########################################
# Deploy Script
# This script handles the deployment process for the Kubernetes
# cluster. It separates CRDs from other resources, applies them,
# and waits for their establishment before proceeding.
# It also cleans up temporary files created during the process.
###########################################

AUTOGENMSG="# This is an auto-generated file. DO NOT EDIT"

separate_crds(){
    # Start with the auto-generated message for each file
    echo "${AUTOGENMSG}" > "crds.yaml"
    echo "${AUTOGENMSG}" > "non-crds.yaml"

    # Extract CRDs and preserve indentation
    awk '/^apiVersion: apiextensions.k8s.io\/v1/ && !inside {inside = 1} /^---/ && inside {print "---"; inside = 0; next} inside {print}' install.yaml >> crds.yaml

    # Extract non-CRDs and preserve indentation
    awk '/^apiVersion: apiextensions.k8s.io\/v1/ {inside = 1} /^---/ && inside {inside = 0; next} !inside {print}' install.yaml >> non-crds.yaml
}

wait_for_crds(){
    for crd in $(kubectl get crd -o name); do
        echo "Waiting for $crd to be established..."
        kubectl wait --for condition=established --timeout=60s $crd
    done
}

deploy(){
    kubectl apply -f crds.yaml
    wait_for_crds
    kubectl apply -f non-crds.yaml
}

cleanup(){
    rm crds.yaml
    rm non-crds.yaml
}

separate_crds
deploy
cleanup
