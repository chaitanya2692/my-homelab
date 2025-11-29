#!/bin/bash

# Define output file
OUTPUT_FILE="all_manifests_combined.txt"

# List of folders to include
FOLDERS=("base" "overlays")

# Ensure the output file is empty before writing
> "$OUTPUT_FILE"

# Iterate through specified folders and find YAML files
for folder in "${FOLDERS[@]}"; do
    find "$folder" -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.sh" \) | while read -r file; do
        echo -e "# File: $file" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        echo "-------------------------------------------------------" >> "$OUTPUT_FILE"
    done
done

echo "Manifest files combined into $OUTPUT_FILE"
