# My Homelab Kubernetes-based HTPC Setup

![htk8s diagrams](system_design.png)

This repository contains the configuration for a Kubernetes-based Home Theater
PC (HTPC) setup running on [k3s](https://k3s.io/), a lightweight Kubernetes
distribution. The system is designed to provide a comprehensive media management
and streaming solution using various open-source applications.

## System Components

The setup includes the following applications:

1. **Media Management**:
   - [Sonarr](https://sonarr.tv/): For managing TV shows
   - [Radarr](https://radarr.video/): For managing movies
   - [Bazarr](https://github.com/morpheus65535/bazarr): For managing subtitles

2. **Download Management**:
   - [Transmission](https://transmissionbt.com/): BitTorrent client for
   downloading media
   - [Jackett](https://github.com/Jackett/Jackett): For searching and managing
   torrent trackers

3. **Media Servers**:
   - [Jellyfin](https://jellyfin.org/): Open-source media server for streaming
   content

4. **Infrastructure**:
   - [Traefik](https://traefik.io/): Reverse proxy and load balancer
   - [cert-manager](https://cert-manager.io/): For managing SSL/TLS certificates
   - [MetalLB](https://metallb.universe.tf/): Load balancer implementation for
   bare metal Kubernetes clusters

## Architecture and System Design

The system is designed using a microservices architecture, with each component
running as a separate service within the Kubernetes cluster. Here's a detailed
breakdown of the architecture:

### 1. Kubernetes Infrastructure

- The system uses k3s as the Kubernetes distribution, providing a lightweight
  and easy-to-install cluster.
- Deployments are managed using Kustomize, allowing for easy customization and
  overlay-based configuration management.
- All applications and services are deployed in the `htpc` namespace.

### 2. Networking and Ingress

- **Traefik** serves as the ingress controller and reverse proxy:
  - Configured using a Helm chart (version 28.0.0) with custom values.
  - Uses LoadBalancer service type with a specific IP.
  - Configured to redirect HTTP to HTTPS.
  - Custom middleware is set up for security headers and authentication.
- **MetalLB** provides a load balancer implementation:
  - Configured to use the IP range 192.168.1.240/28.
  - Set up using a Helm chart (version 0.14.5).
- **cert-manager** automatically manages SSL/TLS certificates:
  - Installed via Helm chart (version 1.14.5).
  - Configured with ClusterIssuer resources for both staging and production
  environments.
  - Uses Cloudflare DNS for ACME DNS-01 challenge.
  - Issues wildcard certificates for *.my-homelab.party.
- Ingress is managed through Traefik IngressRoute custom resources:
  - Each application (Jellyfin, Jackett, Sonarr, etc.) has its own route.
  - The Traefik dashboard is also exposed with basic authentication.

### 3. Storage

- Persistent storage is provided using hostPath volumes, mapping to the
  `/opt/htpc` directory on the host system.
- Each application has its own subdirectory within this storage, ensuring data
  persistence and separation:
  - Transmission: /opt/htpc/transmission
  - Sonarr: /opt/htpc/sonarr
  - Radarr: /opt/htpc/radarr
  - Jackett: /opt/htpc/jackett
  - Bazarr: /opt/htpc/bazarr
  - Jellyfin: /opt/htpc/jellyfin
- Shared directories are used for downloads and media:
  - Downloads: /opt/htpc/downloads
  - TV Shows: /opt/htpc/media/tv
  - Movies: /opt/htpc/media/movies
- Volume mounts are configured in each deployment to map these directories to
  the appropriate locations within containers.
- A PersistentVolumeClaim named "local-path-pvc" is defined, using the
  "local-path" storage class, for potential use by applications requiring
  dynamic provisioning.

### 4. Media Management Workflow

1. **Content Discovery**:
   - Sonarr (TV shows) and Radarr (movies) monitor for new content.
   - They use Jackett to search across multiple torrent trackers.

2. **Download Process**:
   - When new content is found, Sonarr/Radarr send download requests to
   Transmission.
   - Transmission handles the torrent downloads.

3. **Post-Processing**:
   - Once downloads are complete, Sonarr/Radarr move and rename the files to
   the appropriate media directories.
   - Bazarr automatically searches for and downloads subtitles for the new
   content.

4. **Media Serving**:
   - Jellyfin scans the media directories and makes the content available for
   streaming.
   - Users can access the Jellyfin interface through a web browser or compatible
   apps.

### 5. Security and Access

- All services are exposed externally through Traefik, which handles SSL
  termination.
- cert-manager is configured to automatically obtain and renew Let's Encrypt
  certificates.
- Certificates are stored and managed using Cloudflare DNS:
  - The system is configured to use Cloudflare as the DNS provider for DNS-01
  challenge.
  - A Cloudflare API token is stored as a Kubernetes secret for secure access.
  - The domain "my-homelab.party" is used for all services, with subdomains for
  each application.
- Basic authentication is set up for the Traefik dashboard for added security.
- The system uses ClusterIssuer and Certificate custom resources to manage
  SSL/TLS certificates:
  - Staging and production environments have separate issuers.
  - Wildcard certificates are used to cover all subdomains.
- All sensitive information, including API keys and tokens, are stored as
  Kubernetes secrets.

### 6. Configuration Management

- The repository uses a base + overlays structure with Kustomize:
  - `base/` contains the core configurations for all services.
  - `overlays/` contains environment-specific configurations (staging and
  production).
- Environment variables and sensitive data are managed through Kubernetes
  secrets and ConfigMaps.

### 7. Continuous Integration/Continuous Deployment (CI/CD)

- GitHub Actions workflows are set up for automated testing and deployment:
  - Pull Request CI (`push.yml`):
    - Triggered on all pull requests.
    - Runs YAML linting using `yamllint`.
    - Validates Kubernetes manifests using `kubeconform`.
    - Tests the manifest update process.
  - Merge CI (`merge.yml`):
    - Triggered on pushes to the main branch.
    - Updates the `install.yaml` manifest file.
    - Commits and pushes changes if the manifest is modified.
- Scripts in the `scripts/` directory facilitate the CI/CD process:
  - `update-manifests.sh`: Generates the combined `install.yaml` file using
  `kustomize`.
  - `validate.sh`: Runs validation checks on YAML files and Kustomize overlays.
  - `deploy.sh`: Handles the deployment process, including separating CRDs and
  waiting for their establishment.
- The repository uses different configurations for staging and production:
  - Overlays in `overlays/staging/` and `overlays/production/` allow for
  environment-specific settings.
  - CI processes use the production overlay for generating the final manifest.
- Image tags are set to "latest" for all applications in both staging and
  production overlays, allowing for easy updates.

## Secret Management

Sensitive information, such as API keys and tokens, is encrypted using Mozilla
SOPS and stored in the repository. The encryption is done using age encryption
with a public key specified in the `.sops.yaml` file.

The `encrypt-secrets.sh` script is used to encrypt sensitive data in YAML files.
It scans the repository for YAML files containing the `SOPS_SECRET_MARKER`
comment, encrypts the specified fields (data and stringData), and removes the
marker comment.

Encrypted secrets are stored in the respective service directories, such as
`base/cert-manager/issuers/secret-cloudflare-token.yaml`. These secrets are
decrypted during the deployment process using the `SOPS_AGE_KEY_FILE`
environment variable, which points to the age key file.

## Pre-commit Hooks

The repository uses pre-commit hooks to ensure code quality and consistency.
The hooks are defined in the `.pre-commit-config.yaml` file and include:

- `trailing-whitespace`: Trims trailing whitespace.
- `end-of-file-fixer`: Ensures files end with a newline.
- `yamllint`: Lints YAML files using the rules defined in `.yamllint.yml`.
- `markdownlint-cli2`: Lints Markdown files.
- `trufflehog`: Scans for secrets and sensitive information.
- Custom hooks:
  - `print-env`: Prints the pre-commit environment variables to a log file.
  - `test-update-manifests`: Tests the manifest update process.
  - `encrypt-secrets`: Encrypts sensitive data in YAML files.

## Deployment and Usage

1. Ensure you have a k3s cluster set up.
2. Clone this repository to your local machine.
3. Customize the configurations in the `base/` and `overlays/` directories as
  needed.
4. Use the provided scripts in the `scripts/` directory to deploy and manage the
  setup:
   - `update-manifests.sh`: Generates the combined `install.yaml` file.
   - `deploy.sh`: Applies the configurations to your cluster.
   - `validate.sh`: Validates the Kubernetes manifests.

## Credits

This project is inspired by and builds upon
[htk8s](https://github.com/fabito/htk8s).
