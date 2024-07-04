#!/bin/sh -ex

# Function to check if there are changes in relevant files
check_for_changes() {
    git diff --quiet HEAD -- base overlays
    return $?
}

# Function to decrypt secrets
decrypt_secrets() {
    local dir="$1"
    if [ -z "${SOPS_AGE_KEY_FILE:-}" ]; then
        echo "Error: SOPS_AGE_KEY_FILE environment variable is not set."
        exit 1
    fi
    if [ ! -f "$SOPS_AGE_KEY_FILE" ]; then
        echo "Error: Age key file not found at $SOPS_AGE_KEY_FILE"
        exit 1
    fi
    AGE_PUBLIC_KEY=$(grep -oP "public key: \K(.*)" "$SOPS_AGE_KEY_FILE")
    find "$dir" -type f -name '*.yaml' | while read -r file; do
        if grep -q 'sops:' "$file"; then
            echo "Decrypting $file"
            sops --decrypt --age "$AGE_PUBLIC_KEY" --encrypted-regex '^(data|stringData)$' --in-place "$file"
            sed -i '1s/^/# SOPS_SECRET_MARKER\n/' "$file"
            sed -i '1s/^/---\n/' "$file"
        fi
    done
}

local_build(){
    # Decrypt secrets in staging overlay
    decrypt_secrets "${PWD}/base"

    # Build command
    kustomize build "${PWD}/overlays/staging" --enable-helm >> "${PWD}/install.yaml"
    echo "Successfully updated install.yaml"

    # Code cleanup
    find "$PWD" -maxdepth 3 -type d -name 'charts' -exec rm -rf {} \;
}

ci_build(){
    # Decrypt secrets in production overlay
    decrypt_secrets "${PWD}/overlays/production"

    # Build command
    kustomize build "${PWD}/overlays/production" --enable-helm >> "${PWD}/install.yaml"
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
