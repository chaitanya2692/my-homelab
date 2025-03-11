#!/bin/bash
set -e

echo "----------------------------------------------"
echo "Deleting ArgoCD non-CRD resources..."
# Build the non-CRD resources manifest from the app folder
kustomize build "${PWD}/base/infra/argocd/app" --enable-helm --enable-alpha-plugins --enable-exec > app_resources.yaml
# Delete the resources in the argocd namespace
kubectl delete -n argocd -f app_resources.yaml || echo "Non-CRD resources may have already been deleted."

echo "----------------------------------------------"
echo "Deleting argocd namespace..."
# Delete the namespace (this will remove namespaced resources, including secrets)
kubectl delete namespace argocd || echo "Namespace 'argocd' may have already been deleted."

echo "----------------------------------------------"
echo "Deleting CRDs..."
# Build the CRD manifest from the crds folder
kustomize build "${PWD}/base/infra/argocd/crds" --enable-helm --enable-alpha-plugins --enable-exec > crds_resources.yaml
kubectl delete -f crds_resources.yaml || echo "CRDs may have already been deleted."

echo "----------------------------------------------"
echo "All resources have been deleted."
