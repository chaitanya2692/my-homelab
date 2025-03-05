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
   - [Prowlarr](https://prowlarr.com/): For managing indexers and trackers

2. **Download Management**:
   - [Transmission](https://transmissionbt.com/): BitTorrent client for
   downloading media
   - [Jackett](https://github.com/Jackett/Jackett): For searching and managing
   torrent trackers
   - [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr): Proxy server to
   bypass Cloudflare protection

3. **Media Servers**:
   - [Jellyfin](https://jellyfin.org/): Open-source media server for streaming
   content

4. **Infrastructure**:
   - [Traefik](https://traefik.io/): Reverse proxy and load balancer
   - [cert-manager](https://cert-manager.io/): For managing SSL/TLS certificates
   - [MetalLB](https://metallb.universe.tf/): Load balancer implementation for
   bare metal Kubernetes clusters
5. **Utilities**:
   - [Dashy](https://dashy.to/): Dashboard for accessing all services
   - [Nextcloud](https://nextcloud.com/): File hosting and collaboration platform

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
  - Installed using a Helm chart (version 34.4.0).
  - Uses LoadBalancer service type with a specific IP (192.168.1.245).
  - Configured to redirect HTTP to HTTPS.
  - Custom middleware is set up for security headers and authentication.
- **MetalLB** provides a load balancer implementation:
  - - Installed using a Helm chart (version 0.14.9).
  - Configured to use the IP range 192.168.1.240/28.
  - Set up using a Helm chart (version 0.14.5).
- **cert-manager** automatically manages SSL/TLS certificates:
  - Installed via Helm chart (version 1.17.1).
  - Configured with ClusterIssuer resources for both staging and production
  environments.
  - Uses Cloudflare DNS for ACME DNS-01 challenge.
  - Issues wildcard certificates for *.my-homelab.party.
- Ingress is managed through Traefik IngressRoute custom resources:
  - Each application (Jellyfin, Jackett, Sonarr, etc.) has its own route.
  - The Traefik dashboard is also exposed with basic authentication.

### 3. Storage

- Storage is managed using a StorageClass named `cluster-storage` with no provisioner
- Three PersistentVolumes are defined, mapping to host directories:
  - `htpc-pv`: 500GB for media apps, mounted at `/opt/cluster/htpc`
  - `infra-pv`: 100GB for infrastructure, mounted at `/opt/cluster/infra`
  - `utils-pv`: 200GB for utility apps, mounted at `/opt/cluster/utils`
- Corresponding PersistentVolumeClaims are defined in each namespace:
  - `htpc-pvc` in htpc namespace
  - `infra-pvc` in infra namespace
  - `utils-pvc` in utils namespace
- Volume mounts are configured in each deployment to map these directories appropriately

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

### 8. Utility Applications

- **Dashy** provides a centralized dashboard:
  - Custom configured with links to all deployed services
  - Organized into sections for Media, Infrastructure and Storage
  - Protected with basic authentication

- **Nextcloud** provides file storage and collaboration:
  - Uses PostgreSQL database for data persistence
  - Redis cache for improved performance
  - Automated backups for both database and application data
  - Custom security headers and redirects configured via Traefik middleware

## Deployment and Usage

1. Ensure you have a k3s cluster set up.
2. Clone this repository to your local machine.
3. Customize the configurations in the `base/` and `overlays/` directories as
  needed.
4. Use the provided scripts in the `scripts/` directory to deploy and manage the
   setup:
   - `bootstrap.sh`: Initializes the required libraries needed in ubuntu to deploy
   the cluster.
   - `validate.sh`: Validates Kubernetes manifests:
     - Runs kubeconform validation on staging overlay
     - Runs kubeconform validation on production overlay
     - Skips CRD validation and missing schemas
   - `update-manifests.sh`: Generates the combined `install.yaml` file.
   - `deploy.sh`: Applies the configurations to your cluster.
   - `nuke.sh`: Completely removes all resources:
     - Deletes resources from install.yaml
     - Force deletes stuck namespaces if needed
     - Cleans up Docker resources
     - Optionally cleans physical storage

## Credits

This project is inspired by and builds upon [htk8s](https://github.com/fabito/htk8s).
