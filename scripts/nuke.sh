#!/bin/bash

###########################################
# K3s Reset and Reinstall Script
# This script uninstalls existing K3s installation,
# reinstalls it without default load balancer and ingress,
# and sets up the kubeconfig file.
###########################################

# Step 1: Uninstall existing K3s installation
echo "Uninstalling existing K3s installation..."
sudo /usr/local/bin/k3s-uninstall.sh

# Step 2: Install K3s without default components
echo "Installing K3s without ServiceLB and Traefik..."
curl -fL https://get.k3s.io | sh -s - \
    --disable servicelb \
    --disable traefik

# Step 3: Copy kubeconfig to user's home directory
echo "Setting up kubeconfig..."
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

echo "K3s reset and reinstall complete!"
