#!/bin/bash

###########################################
# Bootstrap Script
# This script installs necessary tools and dependencies
# for setting up the Kubernetes-based HTPC environment.
# It includes installations for k3s, Helm, kustomize, kubeseal,
# yq, pip, pre-commit, and Docker.
###########################################

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install essential tools and build dependencies
echo "Installing essential tools and build dependencies..."
sudo apt install -y curl wget git unzip jq build-essential

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install Homebrew if not already installed
if command_exists brew; then
    echo "Homebrew is already installed"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    echo "Adding Homebrew to PATH..."
    echo >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Install GCC via Homebrew
    echo "Installing GCC via Homebrew..."
    brew install gcc
fi

# Check and install kubeconform
if command_exists kubeconform; then
    echo "kubeconform is already installed"
else
    echo "Installing kubeconform..."
    brew install kubeconform
fi

# Check and install k9s
if command_exists k9s; then
    echo "k9s is already installed"
else
    echo "Installing k9s..."
    brew install derailed/k9s/k9s
fi

# Install Docker
if command -v docker &> /dev/null
then
    echo "Docker is already installed"
else
    echo "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed successfully"
fi

# Check and install Helm
if command_exists helm; then
    echo "Helm is already installed"
else
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

# Check and install kustomize
if command_exists kustomize; then
    echo "kustomize is already installed"
else
    echo "Installing kustomize..."
    brew install kustomize
fi

# Check and install kubeseal
if command_exists kubeseal; then
    echo "kubeseal is already installed"
else
    echo "Installing kubeseal..."
    brew install kubeseal
fi

# Check and install yq
if command_exists yq; then
    echo "yq is already installed"
else
    echo "Installing yq..."
    sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
fi

# Check and install pip
if command_exists pip; then
    echo "pip is already installed"
else
    echo "Installing pip..."
    sudo apt install python3-pip -y
fi

# Check and install pre-commit
if command_exists pre-commit; then
    echo "pre-commit is already installed"
else
    echo "Installing pre-commit..."
    sudo apt-get install pre-commit
    pre-commit install
fi

# Install K3s if not already installed
if sudo k3s kubectl get node &> /dev/null; then
    echo "K3s is already installed"
else
    echo "Installing K3s..."
    curl -fL https://get.k3s.io | sh -s - --disable servicelb --disable traefik --disable local-storage
fi

# Set up environment variables
echo "Setting up environment variables..."
if ! grep -q "KUBECONFIG=~/.kube/config" ~/.bashrc; then
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
fi
if ! grep -q "PATH=$PATH:/usr/local/bin" ~/.bashrc; then
    echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
fi

# Create and set up cluster storage directories
echo "Creating cluster storage directories..."
sudo mkdir -p /opt/cluster/{htpc,utils,infra}
sudo chown -R $USER:$USER /opt/cluster
sudo chmod -R 755 /opt/cluster

# Source the updated .bashrc
source ~/.bashrc

echo "Bootstrap complete! Please log out and log back in to ensure all changes take effect."
