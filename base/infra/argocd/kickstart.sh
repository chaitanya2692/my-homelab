kustomize build "${PWD}/base/infra/argocd" --enable-helm --enable-alpha-plugins --enable-exec >> install_argocd.yaml

# # Install cert-manager CRDs if not present
# echo "Checking cert-manager CRDs..."
# if ! kubectl get crd certificaterequests.cert-manager.io &> /dev/null; then
#     echo "Installing cert-manager CRDs..."
#     kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.17.1/cert-manager.crds.yaml
# else
#     echo "cert-manager CRDs already exist"
# fi

# # Install Traefik CRDs if not present
# echo "Checking Traefik CRDs..."
# if ! kubectl get crd ingressroutes.traefik.io &> /dev/null; then
#     echo "Installing Traefik CRDs..."
#     kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/refs/heads/master/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
# else
#     echo "Traefik CRDs already exist"
# fi

kubectl create namespace argocd
kubectl create secret generic sops-age --from-file=/home/chaitanya/.sops/key.txt -n argocd
kubectl apply -n argocd -f install_argocd.yaml

wait_for_pods() {
    echo "Waiting for pods in argocd namespace to be running..."
    while true; do
        # Get the number of pods that are not in Running state
        not_running=$(kubectl get pods -n argocd --no-headers | grep -v "Running" | wc -l)

        if [ $not_running -eq 0 ]; then
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

# kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443
