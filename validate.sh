#!/usr/bin/env bash

set -o errexit

find . -type f -name '*.yaml' -print0 | while IFS= read -r -d $'\0' file;
  do
    echo "INFO - Validating $file"
    yq e 'true' "$file" > /dev/null
done

echo "INFO - Validating clusters"
find ./clusters -type f -name '*.yaml' -maxdepth 1 -print0 | while IFS= read -r -d $'\0' file;
  do
    kubeval ${file} --strict --ignore-missing-schemas
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      exit 1
    fi
done

# mirror kustomize-controller build options
kustomize_flags="--enable_kyaml=false --allow_id_changes=false --load_restrictor=LoadRestrictionsNone"
kustomize_config="kustomization.yaml"

echo "INFO - Validating kustomize overlays"
find . -type f -name $kustomize_config -print0 | while IFS= read -r -d $'\0' file;
  do
    echo "INFO - Validating kustomization ${file/%$kustomize_config}"
    kustomize build "${file/%$kustomize_config}" $kustomize_flags | \
      kubeval --ignore-missing-schemas --strict
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      exit 1
    fi
done
