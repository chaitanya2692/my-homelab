#!/bin/bash
set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Namespaces to clean up
NAMESPACES=("htpc" "infra" "utils" "argocd")

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# Function to force delete a namespace
force_delete_namespace() {
    local namespace=$1
    log "Force deleting namespace: $namespace"

    kubectl get namespace "$namespace" -o json > "tmp_${namespace}.json"

    # Remove kubernetes from finalizers
    cat "tmp_${namespace}.json" | jq '.spec = {"finalizers":[]}' > "tmp_${namespace}_updated.json"

    # Force delete the namespace
    kubectl replace --raw "/api/v1/namespaces/${namespace}/finalize" -f "tmp_${namespace}_updated.json"
    rm -f "tmp_${namespace}.json" "tmp_${namespace}_updated.json"

    log "Namespace $namespace force deleted"
}

# Function to clean docker resources
clean_docker() {
    log "Cleaning Docker resources..."

    # Remove unused volumes
    if docker volume prune -f; then
        log "Docker volumes cleaned"
    else
        warn "Error cleaning Docker volumes"
    fi

    # Remove unused containers, networks, images
    if docker system prune -a -f; then
        log "Docker system cleaned"
    else
        warn "Error cleaning Docker system"
    fi
}

# Main cleanup process
main() {
    log "Starting cleanup process..."

    # Delete resources from install.yaml if it exists
    if [ -f "install.yaml" ]; then
        log "Deleting resources from install.yaml..."
        kubectl delete -f install.yaml --timeout=60s --wait=false || true
        log "Resources from install.yaml deleted"
    else
        warn "install.yaml not found, skipping resource deletion"
    fi

    # Clean up each namespace
    for namespace in "${NAMESPACES[@]}"; do
        if kubectl get namespace "$namespace" >/dev/null 2>&1; then
            log "Processing namespace: $namespace"

            # Wait for namespace deletion (up to 60 seconds)
            for i in {1..2}; do
                if ! kubectl get namespace "$namespace" >/dev/null 2>&1; then
                    break
                fi
                log "Waiting for $namespace namespace deletion... attempt $i/12"
                sleep 5
            done

            # Force delete namespace if still exists
            if kubectl get namespace "$namespace" >/dev/null 2>&1; then
                warn "Namespace $namespace still exists, attempting force deletion..."
                force_delete_namespace "$namespace"
            fi
        else
            warn "Namespace $namespace not found, skipping"
        fi
    done

    # Clean Docker resources
    clean_docker

    # Optionally clean physical storage (commented out for safety)
    # warn "To clean physical storage, uncomment and run:"
    # warn "sudo rm -rf /opt/cluster/htpc"
    # warn "sudo rm -rf /opt/cluster/infra"
    # warn "sudo rm -rf /opt/cluster/utils"

    log "Cleanup completed successfully"
}

# Execute main function with error handling
if main; then
    log "Script completed successfully"
else
    error "Script failed!"
    exit 1
fi
