#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install essential tools
echo "Installing essential tools..."
sudo apt install -y curl wget git unzip jq

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check and install k9s
if command_exists k9s; then
    echo "k9s is already installed"
else
    echo "Installing k9s..."
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo k9s.tar.gz "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
    tar -xzf k9s.tar.gz
    sudo mv k9s /usr/local/bin/
    rm k9s.tar.gz LICENSE README.md
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
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    sudo mv kustomize /usr/local/bin/
fi

# Check and install SOPS
if command_exists sops; then
    echo "SOPS is already installed"
else
    echo "Installing SOPS..."
    SOPS_VERSION=$(curl  "https://api.github.com/repos/getsops/sops/tags" | jq -r '.[0].name')
    curl -LO https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64
    sudo mv sops-${SOPS_VERSION}.linux.amd64 /usr/local/bin/sops
    chmod +x /usr/local/bin/sops
fi

# Check and install ksops
if command_exists ksops; then
    echo "ksops is already installed"
else
    echo "Installing ksops..."
    curl -s https://raw.githubusercontent.com/viaduct-ai/kustomize-sops/master/scripts/install-ksops-archive.sh | bash
fi

# Check and install ksops
if command_exists age; then
    echo "age is already installed"
else
    echo "Installing age..."
    sudo apt install age
    mkdir ~/.sops
    # The key needs to be present in home folder before the next step
    if [ ! -f ~/key.txt ]; then
        echo "AGE Key not found."
        exit 1
    fi
    mv ~/key.txt ~/.sops
    export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt
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
    pip3 install pre-commit --break-system-packages
    pre-commit install
fi

# Set up environment variables
echo "Setting up environment variables..."
if ! grep -q "KUBECONFIG=/etc/rancher/k3s/k3s.yaml" ~/.bashrc; then
    echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
fi
if ! grep -q "PATH=$PATH:/usr/local/bin" ~/.bashrc; then
    echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
fi

# Source the updated .bashrc
source ~/.bashrc

echo "Bootstrap complete! Please log out and log back in to ensure all changes take effect."
