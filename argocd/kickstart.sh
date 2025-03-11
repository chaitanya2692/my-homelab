#!/bin/bash
set -e

# Step 1: Build and apply CRDs
echo "Building and applying CRDs..."
kustomize build "${PWD}/argocd/crds" --enable-helm --enable-alpha-plugins --enable-exec > crds.yaml
kubectl apply -f crds.yaml

# Wait for the ArgoCD Application CRD to be established
echo "Waiting for the ArgoCD Application CRD to be established..."
kubectl wait --for=condition=Established --timeout=60s crd/applications.argoproj.io

# Step 2: Ensure the argocd namespace exists and create the sops secret
echo "Creating namespace and sops secret..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic sops-age --from-file=/home/chaitanya/.sops/key.txt -n argocd --dry-run=client -o yaml | kubectl apply -f -

# Step 3: Build and apply the rest of the application
echo "Building and applying ArgoCD application resources..."
kustomize build "${PWD}/argocd/app" --enable-helm --enable-alpha-plugins --enable-exec > install_argocd.yaml
kubectl apply -n argocd -f install_argocd.yaml

# Step 4: Wait for all pods to be running
wait_for_pods() {
    echo "Waiting for pods in argocd namespace to be running..."
    while true; do
        not_running=$(kubectl get pods -n argocd --no-headers | grep -v "Running" | wc -l)
        if [ "$not_running" -eq 0 ]; then
            echo "All pods in argocd namespace are running."
            break
        else
            echo "Waiting for $not_running pod(s) to be in Running state..."
            sleep 10
        fi
    done
}
wait_for_pods

echo "----------------------------------------------------"
echo "ArgoCD secret password:"
kubectl get secrets/argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d
echo ""

# To temporarily expose the ArgoCD UI before the ingressroute is active, run the following command:
# kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443
