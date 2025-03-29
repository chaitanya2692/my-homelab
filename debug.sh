#!/bin/bash
set -euo pipefail

# Check if namespace argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE="$1"
TIMEOUT_SECONDS=1       # Timeout for each deletion command (in seconds)
MAX_RETRIES=3            # Maximum deletion attempts per resource type
SLEEP_INTERVAL=2         # Seconds to wait between deletion rounds

# List of Longhorn-related resource types in the namespace
resource_types=(
    "backuptarget.longhorn.io"
    "engineimage.longhorn.io"
    "engine.longhorn.io"
    "replica.longhorn.io"
    "volumeattachment.longhorn.io"
    "volume.longhorn.io"
    "node.longhorn.io"
)

# Function to delete a single resource with a fallback to remove finalizers
delete_resource() {
    local resource_type="$1"
    local resource_name="$2"
    echo "Deleting ${resource_type} ${resource_name} in namespace ${NAMESPACE}..."

    # First deletion attempt with a timeout
    if timeout "${TIMEOUT_SECONDS}" kubectl delete "${resource_type}" "${resource_name}" -n "${NAMESPACE}" --ignore-not-found; then
        echo "Successfully deleted ${resource_type} ${resource_name}."
    else
        echo "Deletion failed for ${resource_type} ${resource_name}. Attempting to remove finalizers..."
        # Attempt to patch to remove finalizers
        if kubectl patch "${resource_type}" "${resource_name}" -n "${NAMESPACE}" --type=merge -p '{"metadata":{"finalizers":[]}}'; then
            echo "Finalizers removed for ${resource_type} ${resource_name}."
        else
            echo "Failed to remove finalizers for ${resource_type} ${resource_name}."
        fi
        sleep 1
        echo "Retrying deletion of ${resource_type} ${resource_name}..."
        timeout "${TIMEOUT_SECONDS}" kubectl delete "${resource_type}" "${resource_name}" -n "${NAMESPACE}" --ignore-not-found || \
          echo "Deletion still failing for ${resource_type} ${resource_name}."
    fi
}

echo "=========================================="
echo "Starting cleanup of Longhorn orphaned resources in namespace: ${NAMESPACE}"
echo "=========================================="
echo ""

# Loop over each resource type and attempt deletion robustly
for resource_type in "${resource_types[@]}"; do
    attempt=1
    while [ $attempt -le $MAX_RETRIES ]; do
        echo "Attempt $attempt for resource type ${resource_type}..."
        # List resources of the given type in the namespace
        resources=$(kubectl get "${resource_type}" -n "${NAMESPACE}" --no-headers 2>/dev/null | awk '{print $1}' || true)
        if [ -z "$resources" ]; then
            echo "No resources of type ${resource_type} found in namespace ${NAMESPACE}."
            break
        fi

        for resource in $resources; do
            delete_resource "${resource_type}" "${resource}"
            sleep 1
        done

        sleep "${SLEEP_INTERVAL}"
        # Re-check for remaining resources of this type
        remaining=$(kubectl get "${resource_type}" -n "${NAMESPACE}" --no-headers 2>/dev/null | awk '{print $1}' || true)
        if [ -z "$remaining" ]; then
            echo "All resources of type ${resource_type} have been deleted."
            break
        else
            echo "Remaining ${resource_type} resources: $remaining"
        fi

        attempt=$((attempt + 1))
    done
    echo ""
done

echo "=========================================="
echo "Cleanup of Longhorn orphaned resources in namespace ${NAMESPACE} completed."
echo "=========================================="
