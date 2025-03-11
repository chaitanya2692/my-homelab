#!/bin/env bash
set -euo pipefail

###########################################
# Encrypt Secrets Script
# This script encrypts YAML files containing the SOPS_SECRET_MARKER
# using SOPS and Age. It checks for the presence of the marker,
# encrypts the file, and updates the file in place.
# It requires the SOPS_AGE_KEY_FILE environment variable to be set.
###########################################

# Check if SOPS_AGE_KEY_FILE is set
if [ -z "${SOPS_AGE_KEY_FILE:-}" ]; then
    echo "Error: SOPS_AGE_KEY_FILE environment variable is not set."
    exit 1
fi

# Check if the key file exists
if [ ! -f "$SOPS_AGE_KEY_FILE" ]; then
    echo "Error: Age key file not found at $SOPS_AGE_KEY_FILE"
    exit 1
fi

# Get the repository root
repo_root=$(git rev-parse --show-toplevel)

# Flag to track if any files were encrypted
files_encrypted=0

# Find all YAML files
while IFS= read -r -d '' file; do
    # Check if the file contains the secret marker
    if grep -q 'SOPS_SECRET_MARKER' "$file"; then
        echo "Encrypting $file"
        if sops --encrypt --age "$(grep -oP "public key: \K(.*)" "$SOPS_AGE_KEY_FILE")" --encrypted-regex '^(data|stringData)$' --in-place "$file"; then
            # Remove the SOPS_SECRET_MARKER and add YAML separator if not present
            sed -i '1s/^/---\n/' "$file"
            sed -i '/^# SOPS_SECRET_MARKER$/d' "$file"
            echo "Successfully encrypted $file"
            files_encrypted=$((files_encrypted + 1))
        else
            echo "Failed to encrypt $file"
            exit 1
        fi
    fi
done < <(find "$repo_root" -type f -name '*.yaml' -print0)

# Check if any files were encrypted
if [ "$files_encrypted" -gt 0 ]; then
    echo "Successfully encrypted $files_encrypted file(s)"
    exit 0
else
    echo "No files needed encryption"
    exit 0
fi
