#!/bin/bash

# transmission_k8s_full_diag.sh
# Collects pod and storage diagnostics for Transmission permissions issues in Kubernetes.

NAMESPACE="htpc"
OUTFILE="transmission_full_diag_logs.txt"

echo "===== ARR + Transmission K8s Diagnostics: $(date) =====" > "$OUTFILE"

echo -e "\n--- Pod List ---" >> "$OUTFILE"
kubectl get pods -n $NAMESPACE >> "$OUTFILE"

echo -e "\n--- Pod Status/Describe (Running + CrashLoopBackOff) ---" >> "$OUTFILE"
kubectl describe pod transmission-6d6fc99c5c-kvbc7 -n $NAMESPACE >> "$OUTFILE" 2>&1
kubectl describe pod transmission-7f8b79f9f-5v422 -n $NAMESPACE >> "$OUTFILE" 2>&1

echo -e "\n--- Pod Logs (CrashLoop + Running) ---" >> "$OUTFILE"
kubectl logs -n $NAMESPACE transmission-6d6fc99c5c-kvbc7 --all-containers=true >> "$OUTFILE" 2>&1
kubectl logs -n $NAMESPACE transmission-7f8b79f9f-5v422 --all-containers=true >> "$OUTFILE" 2>&1

echo -e "\n--- PVC Info ---" >> "$OUTFILE"
kubectl get pvc -n $NAMESPACE -o wide >> "$OUTFILE"
kubectl get pvc htpc-pvc -n $NAMESPACE -o yaml >> "$OUTFILE"

echo -e "\n--- Pod Volume Mounts (Running) ---" >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- mount >> "$OUTFILE" 2>&1

echo -e "\n--- Filesystem Ownership/Permissions (Running Pod) ---" >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'ls -ld /downloads /downloads/incomplete /downloads/tv-sonarr 2>/dev/null || true' >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'ls -ld /data/torrents /data/torrents/incomplete /data/torrents/tv-sonarr 2>/dev/null || true' >> "$OUTFILE"

echo -e "\n--- Filesystem Write Test (Running Pod) ---" >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'touch /downloads/k8s_diag_test 2>&1; ls -la /downloads' >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'touch /downloads/incomplete/k8s_diag_test 2>&1; ls -la /downloads/incomplete' >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'touch /downloads/tv-sonarr/k8s_diag_test 2>&1; ls -la /downloads/tv-sonarr' >> "$OUTFILE"

echo -e "\n--- Container Identity (Running Pod) ---" >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- id >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- whoami 2>&1 >> "$OUTFILE"

echo -e "\n--- getfacl Output (Running Pod) ---" >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'getfacl /downloads/incomplete 2>&1' >> "$OUTFILE"
kubectl exec -n $NAMESPACE transmission-7f8b79f9f-5v422 -- bash -c 'getfacl /downloads/tv-sonarr 2>&1' >> "$OUTFILE"

echo -e "\n--- End Diagnostics ---" >> "$OUTFILE"

echo "Done! Results saved in $OUTFILE"
