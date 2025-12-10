# Prerequisites

Before deploying the homelab platform, ensure you have the following prerequisites in place.

## System Requirements

### Hardware

- **CPU**: Minimum 4 cores (8 cores recommended)
- **RAM**: Minimum 8GB (16GB+ recommended)
- **Storage**: Minimum 100GB available disk space
- **Network**: Stable internet connection with static IP or DDNS

### Operating System

- Ubuntu 20.04 LTS or newer (recommended)
- Debian 10 or newer
- Other Linux distributions with systemd support

## Software Dependencies

### Required Tools

=== "k3s"

    The lightweight Kubernetes distribution that powers the platform.

    ```bash
    # Install k3s (automatically installed by bootstrap.sh with custom flags)
    curl -fL https://get.k3s.io | sh -s - --disable servicelb --disable traefik --disable local-storage

    # Verify installation
    sudo k3s kubectl get nodes
    ```

    !!! info "Bootstrap Automation"
        The bootstrap script installs k3s with these flags automatically. Manual installation is only needed
        if not using the bootstrap script.

    For multi-node setups, refer to the [k3s documentation](https://docs.k3s.io/).

=== "kubectl"

    Command-line tool for interacting with Kubernetes.

    ```bash
    # kubectl is included with k3s
    # Create an alias for convenience
    echo "alias kubectl='sudo k3s kubectl'" >> ~/.bashrc
    source ~/.bashrc

    # Or copy kubeconfig for non-root access
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $USER:$USER ~/.kube/config
    chmod 600 ~/.kube/config
    ```

=== "Git"

    Version control system for cloning the repository.

    ```bash
    # Install Git
    sudo apt update
    sudo apt install -y git

    # Verify installation
    git --version
    ```

### Additional Tools

!!! info "Installed by Bootstrap"
    These tools are automatically installed by the `bootstrap.sh` script:

    - **helm**: Package manager for Kubernetes
    - **k9s**: Terminal-based UI for Kubernetes
    - **kustomize**: Template-free Kubernetes configuration
    - **sops** and **age**: Secret encryption tools
    - **kubeconform**: Kubernetes manifest validation

## Network Configuration

### IP Address Planning

The platform requires a dedicated IP range for LoadBalancer services:

- **MetalLB IP Range**: 192.168.1.240/28 (16 addresses)
- **Traefik LoadBalancer**: 192.168.1.245 (static assignment)

!!! warning "IP Conflicts"
    Ensure the IP range doesn't overlap with your DHCP server's allocation pool.

### DNS Setup

For external access with TLS certificates:

1. **Domain Name**: Register or use an existing domain
2. **DNS Provider**: Cloudflare recommended (for DNS-01 challenges)
3. **Wildcard DNS**: Point `*.yourdomain.com` to your external IP

### Firewall Rules

Open the following ports if you have a firewall:

| Port | Protocol | Service | Purpose |
| ---- | -------- | ------- | ------- |
| 80 | TCP | HTTP | Traefik ingress (redirects to 443) |
| 443 | TCP | HTTPS | Traefik ingress (TLS) |
| 6443 | TCP | Kubernetes API | k3s API server |

## Storage Preparation

### Cluster Storage Directories

The bootstrap script automatically creates storage directories at `/opt/cluster`:

```bash
# These are created automatically by bootstrap.sh
/opt/cluster/htpc
/opt/cluster/utils
/opt/cluster/infra
```

### Local Path Provisioner

The platform uses local-path-provisioner for dynamic storage provisioning with namespace-specific storage classes.
Storage paths are automatically created by the bootstrap script at:

- `/opt/cluster/htpc` - Media services storage
- `/opt/cluster/infra` - Infrastructure services storage
- `/opt/cluster/utils` - Utility services storage

### Media Storage

For media services, prepare a dedicated storage location:

    ```bash
    # Example: External drive mount
    sudo mkdir -p /mnt/media
    # Mount your external storage here
    ```

## Credentials and Secrets

Prepare the following credentials before deployment:

### Age Encryption Key

!!! warning "Required Before Bootstrap"
    An Age encryption key must exist at `~/key.txt` **before** running the bootstrap script. The script will move it to `~/.sops/key.txt`.

Generate an Age key:

```bash
# Install age (if not already installed)
sudo apt install age

# Generate a new key
age-keygen -o ~/key.txt

# Backup your key securely!
# Without this key, you cannot decrypt secrets
```

!!! danger "Backup Your Key"
    Store your Age key in a secure location (password manager, encrypted backup). Without it, you cannot decrypt your secrets!

### Required Secrets

- **Age Key** (for SOPS encryption) - **REQUIRED**
- **Cloudflare API Token** (for cert-manager DNS-01 challenges)
- **ArgoCD Admin Password** (generated during installation)
- **Service-specific credentials** (database passwords, API keys, etc.)

!!! info "Secret Management"
    Secrets should be created before deployment. See the [Secrets](../configuration/secrets.md) configuration guide for details.

## Validation Checklist

Before proceeding to installation, verify:

- [ ] k3s cluster is running
- [ ] kubectl can access the cluster
- [ ] Git is installed
- [ ] IP range is reserved and available
- [ ] DNS configuration is complete (if using external access)
- [ ] Storage paths are prepared
- [ ] Required secrets are documented

!!! success "Ready to Install"
    Once all prerequisites are met, proceed to the [Installation](installation.md) guide.
