cd argocd
kustomize build --enable-helm --enable-alpha-plugins --enable-exec >> install_argocd.yaml

kubectl create namespace argocd
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

kubectl port-forward svc/argocd-server -n argocd 8080:443
