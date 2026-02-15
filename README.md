# 🏠 My Kubernetes Homelab Platform

![htk8s diagrams](test_link.svg)

> 🚀 A modern, extensible homelab powered by Kubernetes

This repository contains the configuration for a comprehensive Kubernetes-based homelab
platform running on [k3s](https://k3s.io/). The system is designed as a modular,
scalable foundation for home automation, media management, personal cloud services,
and infrastructure experimentation. Built with cloud-native principles, it enables
easy addition of new services while maintaining security and reliability.

> 💡 **Design Philosophy**: This setup embraces the Infrastructure as Code (IaC)
> paradigm, using declarative configurations to ensure reproducibility and
> maintainability. The architecture follows cloud-native principles while being
> optimized for home deployment.

## ✨ Platform Capabilities

- 🏗️ **Enterprise-Grade Infrastructure**
  - Production-ready Kubernetes platform
  - High availability configuration options
  - Declarative infrastructure management
  - Multi-environment support (staging/production)

- ☁️ **Personal Cloud Services**
  - File sync and sharing (Nextcloud)
  - Photo management with AI features (Immich)
  - Recipe organization and meal planning (Tandoor)
  - Expandable for additional services

- 🎬 **Media Center Functionality**
  - Automated content management
  - Streaming server capabilities
  - Multi-device access
  - Quality optimization

- 🔒 **Zero-Trust Security Model**
  - End-to-end encryption for all services
  - Certificate-based authentication
  - Network policy enforcement
  - Secrets management

- 🔄 **Modern DevOps Practices**
  - GitOps-based deployment
  - Continuous integration/deployment
  - Infrastructure as Code
  - Automated operations
  - Automated dependency management (Renovate)

- 📊 **Enterprise Monitoring**
  - Full observability stack (Prometheus, Grafana, Loki, Jaeger)
  - Pre-configured Grafana dashboards for all services
  - ServiceMonitor-based metrics collection
  - Distributed tracing
  - Centralized logging
  - Performance analytics

- 🎛️ **Advanced Networking**
  - Software-defined networking
  - Load balancing
  - Ingress control
  - Service mesh ready

- 🔧 **Platform Extensibility**
  - Modular architecture
  - Easy service integration
  - Custom resource definitions
  - API-driven management

- 📱 **Mobile-friendly interface**
  - Responsive design across all services
  - Native app support where available
  - Progressive Web App capabilities

## 🧩 Platform Services

### 🖥️ Core Platform

| Logo | Service | Description |
| ------ | ------ | ------ |
| <img src="https://k3s.io/img/k3s-logo-light.svg" alt="k3s logo" height="40"> | [k3s](https://k3s.io/) | Lightweight Kubernetes |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/argo-cd.svg" alt="ArgoCD logo" height="40"> | [ArgoCD](https://argoproj.github.io/cd/) | GitOps Deployment |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/traefik.svg" alt="Traefik logo" height="40"> | [Traefik](https://traefik.io/) | Ingress Controller |
| <img src="https://raw.githubusercontent.com/cert-manager/cert-manager/master/logo/logo.svg" alt="cert-manager logo" height="40"> | [cert-manager](https://cert-manager.io/) | Certificate Management |
| <img src="https://raw.githubusercontent.com/metallb/metallb/main/website/static/images/logo/metallb-blue.svg" alt="MetalLB logo" height="40"> | [MetalLB](https://metallb.universe.tf/) | Load Balancer |

### 🔭 Observability

| Logo | Service | Description |
| ------ | ------ | ------ |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/prometheus.svg" alt="Prometheus logo" height="40"> | [Prometheus](https://prometheus.io/) | Metrics Collection |
| <img src="https://raw.githubusercontent.com/grafana/grafana/main/public/img/grafana_icon.svg" alt="Grafana logo" height="40"> | [Grafana](https://grafana.com/) | Visualization |
| <img src="https://grafana.com/static/img/logos/logo-loki.svg" alt="Loki logo" height="40"> | [Loki](https://grafana.com/oss/loki/) | Log Aggregation |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/jaeger.svg" alt="Jaeger logo" height="40"> | [Jaeger](https://www.jaegertracing.io/) | Distributed Tracing |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/alloy.svg" alt="Grafana Alloy logo" height="40"> | [Alloy](https://www.jaegertracing.io/) | OpenTelemetry Collector |

### ☁️ Personal Cloud

| Logo | Service | Description |
| ------ | --------- | ------------- |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/nextcloud.svg" alt="Nextcloud logo" width="40"> | [Nextcloud](https://nextcloud.com/) | File Sync & Share |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/png/homepage.png" alt="Homepage logo" height="40"> | [Homepage](https://gethomepage.dev/) | Service Dashboard |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/immich.svg" alt="Immich logo" height="40"> | [Immich](https://immich.app/) | Photo Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/tandoor-recipes.svg" alt="Tandoor logo" height="40"> | [Tandoor](https://tandoorrecipes.com/) | Recipe Management |

### 🎬 Media Services

| Logo | Service | Description |
| ------ | --------- | ------------- |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/jellyfin.svg" alt="Jellyfin logo" height="40"> | [Jellyfin](https://jellyfin.org/) | Media Streaming |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/sonarr.svg" alt="Sonarr logo" height="40"> | [Sonarr](https://sonarr.tv/) | TV Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/radarr.svg" alt="Radarr logo" height="40"> | [Radarr](https://radarr.video/) | Movie Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/prowlarr.svg" alt="Prowlarr logo" height="40"> | [Prowlarr](https://prowlarr.com/) | Index Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/transmission.svg" alt="Transmission logo" height="40"> | [Transmission](https://transmissionbt.com/) | BitTorrent Client |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/png/flaresolverr.png" alt="FlareSolverr logo" height="40"> | [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) | CAPTCHA Solver |
| <img src="https://raw.githubusercontent.com/thecfu/scraparr/refs/heads/dev/.github/assets/logos/scraparr_logo.svg" alt="Scraparr logo" height="40"> | [Scraparr](https://github.com/TheCfu/Scraparr) | Metadata Scraper |

### 🗄️ Data Layer

| Logo | Service | Description |
| ------ | --------- | ------------- |
| <img src="https://cloudnative-pg.io/images/hero_image.png" alt="CNPG logo" height="40"> | [CloudNativePG](https://cloudnative-pg.io/) | PostgreSQL Operator |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/valkey.svg" alt="Valkey logo" height="40"> | [Valkey](https://valkey.io/) | (Immich) Caching Layer |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/redis.svg" alt="Redis logo" height="40"> | [Redis](https://redis.io/) | (General) Caching Layer |

## 🏗️ Architecture and System Design

The system employs a modern microservices architecture, with each component running as a
Kubernetes service. Here's the detailed breakdown:

### 1. 🛠️ Kubernetes Infrastructure

- ⚡ **Lightweight**: k3s-based Kubernetes distribution
  - Optimized for resource-constrained environments
  - Single binary installation
  - Built-in containerd runtime
  - Automated TLS certificate generation

- 🔄 **Flexible**: Kustomize for configuration management
  - Declarative configuration using overlays
  - Environment-specific customizations
  - Base configurations for reusability
  - No templating engine required

- 🏢 **Organized**: Three dedicated namespaces
  - `htpc`: Media management and streaming services
  - `infra`: Core infrastructure components
  - `utils`: Supporting applications and tools
  - Resource isolation and quota management

> 💡 **Architecture Note**: The infrastructure follows the principle of separation
> of concerns, with each namespace serving a specific purpose and having its own
> resource quotas and security policies.

### 2. 🌐 Networking and Ingress

#### 🚦 Traefik

```yaml
Features:
- 🔀 LoadBalancer (IP: 192.168.1.245)
  - Static IP allocation for stable access
  - External service exposure
  - Layer 4 and Layer 7 routing

- 🔒 HTTPS Redirect
  - Automatic HTTP to HTTPS redirection
  - TLS termination at the edge
  - Modern TLS versions support

- 🛡️ Security Headers
  - HSTS implementation
  - XSS protection
  - Content Security Policy
  - Frame protection

- 🔑 Authentication
  - Basic auth support
  - Forward authentication
  - Custom middleware chains
```

> 💡 **Design Choice**: Traefik was chosen for its ease of configuration,
> Kubernetes-native integration, and robust feature set that allows for
> both simple and complex routing scenarios.

#### 🛠️ MetalLB

```yaml
Configuration:
- 🌐 IP Range: 192.168.1.240/28
  - 16 assignable IP addresses
  - Reserved network segment
  - ARP mode for layer 2

- ⚖️ Load Balancing Features
  - BGP support (if needed)
  - Automated failover
  - Address assignment
```

> 💡 **Network Design**: The IP range is carefully chosen to avoid conflicts
> with DHCP and other network services while providing enough addresses for
> all planned services.

#### 🔐 cert-manager

- 🎯 Let's Encrypt Integration
- ☁️ Cloudflare DNS-01 Challenge
- 🌟 Wildcard Certificates (*.my-homelab.party)
- 📊 Prometheus Metrics Integration

### 3. 💾 Storage Architecture

The storage architecture is designed with the following principles:

- **Dynamic Provisioning**
  - Automated volume management
  - Just-in-time resource allocation
  - Flexible capacity planning

- **Namespace Isolation**
  - Dedicated StorageClasses per namespace
  - Independent scaling capabilities
  - Granular access control

- **Performance Optimization**
  - Local path provisioning for low latency
  - Direct volume access
  - Optimized for media streaming

> 💡 **Storage Design**: The storage architecture prioritizes performance and
> reliability while maintaining flexibility for future growth.

| Namespace | PVC | Size | Purpose | Design Considerations |
| ----------- | ----- | ------ | --------- | --------------------- |
| htpc | htpc-pvc | Shared | Media & App Data | High throughput, large files |
| infra | grafana-data-pvc | 5GB | Dashboards | Fast random access |
| | jaeger-data-pvc | 10GB | Tracing | High write frequency |
| utils | immich-library-pvc | 20GB | Photos/Videos | Mixed IO patterns |
| | immich-valkey-pvc | 5GB | Cache | In-memory performance |
| | immich-ml-cache-pvc | 10GB | ML Models | Read-optimized |
| | nextcloud-pvc | 31GB | Files | Mixed workload |
| | nextcloud-redis-pvc | 1GB | Redis Data | Fast access |
| | tandoor-data-pvc | 20GB | Recipes | Small files, frequent access |

> 🔄 All storage is dynamically provisioned by local-path-provisioner

### 4. 📺 Media Management Architecture

The media management system is built on four key pillars:

1. **Content Discovery** 🔍
   - Automated series tracking
   - Quality profile management
   - Release group preferences
   - Metadata enrichment

   ```mermaid
   graph TD
     A[Series/Movie Added] --> B[Quality Profile Check]
     B --> C[Search Indexers]
     C --> D[Filter Results]
     D --> E[Queue for Download]
   ```

2. **Download Orchestration** 📥
   - Automated download management
   - Rate limiting and scheduling
   - VPN integration capabilities
   - Download verification

   ```mermaid
   graph TD
     A[Download Request] --> B[Transmission]
     B --> C[Progress Monitoring]
     C --> D[Hash Verification]
     D --> E[Completion Handling]
   ```

3. **Post-Processing Pipeline** 🔄
   - Automated file organization
   - Quality analysis and upgrade
   - Metadata embedding
   - Subtitle management

   ```mermaid
   graph TD
     A[Download Complete] --> B[Quality Check]
     B --> C[Rename/Organize]
     C --> D[Fetch Subtitles]
     D --> E[Update Library]
   ```

4. **Media Serving Strategy** 🎬
   - Direct Play optimization
   - Hardware transcoding support
   - Adaptive streaming
   - Client-specific optimization
   - Advanced bitstreaming with dedicated hardware for lossless audio/video passthrough

   ```mermaid
   graph TD
     A[Client Request] --> B[Format Check]
     B --> C{Can Direct Play?}
     C -->|Yes| D[Direct Play<br/>Original Format<br/>No Processing]
     C -->|No| E{Can Direct Stream?}
     E -->|Yes| F[Direct Stream<br/>Remux Container<br/>No Re-encoding]
     E -->|No| G[Transcode<br/>Re-encode<br/>Server Processing]
     D --> H[Bitstreaming Supported?]
     F --> H
     H -->|Yes| I[Hardware Passthrough]
     H -->|No| J[Software Decode]
   ```

   #### Advanced Hardware Setup for Bitstreaming

   For optimal quality with high-end audio/video formats, a dedicated client setup
   eliminates transcoding issues common with TV-integrated clients:

   - **Client Device**: [Homatics Box R 4K Plus](https://www.homatics.com/products/box-r-4k-plus) running [CoreElec](https://coreelec.org/)
     - Enables hardware-accelerated decoding and HDMI passthrough for Dolby Vision, HDR10/10+,
       Dolby Atmos, DTS:X, and lossless codecs. (Ref: [Device Codec Compatibility](https://docs.google.com/spreadsheets/u/0/d/15i0a84uiBtWiHZ5CXZZ7wygLFXwYOd84/htmlview#gid=845372636))
     - Avoids transcoding limitations of WebOS clients that force AAC audio conversion and
       HDR fallbacks from Dolby Vision 7.

   - **Connection Chain**: Router —> LAN —> Homatics Box —> HDMI —> Samsung HW-Q995D Soundbar —> HDMI eARC —> LG G4 TV.
     - **Compatibility**: Full support for Dolby Vision 7.6 (with FEL) and Dolby TrueHD Atmos lossless audio
       passthrough. (Ref: [Test Results](https://discourse.coreelec.org/t/ce-ng-dolby-vision-fel-for-dv-licensed-socs-s905x2-s922x-z-s905x4/50953))

   - **Key Advantages**:
     - Eliminates audio transcoding to AAC and video fallbacks to standard HDR
     - Reduces latency and server load through direct bitstreaming
     - Future-proofs for 8K/120Hz content with HDMI 2.1 compliance

    > 💡 **Hardware Optimization**: This setup prioritizes direct play over compatibility,
    > ensuring lossless transmission of advanced formats like Dolby Vision 7 and Dolby Atmos
    > through the entire chain.

   #### Setup Instructions

   ##### Initial Installation

    - Get a USB Drive and flash [CoreELEC 21.3](https://github.com/CoreELEC/CoreELEC/releases/download/21.3-Omega/CoreELEC-Amlogic-ng.arm-21.3-Omega-Generic.img.gz)
     using [Balena Etcher](https://etcher.balena.io/).
    - Browse to the Device Trees folder on USB flash drive, and:
      - Copy the correct `sc2_s905x4_sei_smb_280.dtb` image file for the device to the root folder, the same level as `kernel.img`
      - Rename it to `dtb.img` (ignore any warnings after renaming)
    - Copy the [dovi.ko](https://drive.google.com/file/d/1985DIi9Bh6ZIm2IXCpCuhCvQQk9xCNCQ/view?usp=drive_link) file
      into the same location.
    - Insert the USB drive into any of the USB ports on the box and insert the power adapter. The device should boot
      to CoreELEC via the USB.
      - If not, either restart the device from the Android TV GUI until it identifies the USB drive or try the reset
        button technique on the [official website](https://wiki.coreelec.org/coreelec:ceboot) and try to reboot from
        the android recovery menu
    - Once you see the CoreELEC logo and the OS has successfully booted, complete the initial setup
      - Enable SSH for debugging or development (recommended)

   ##### Kodi Configuration

   **Cache Settings** (Settings → Services → [Caching](https://kodi.wiki/view/Settings/Services/Caching))
    - Turn on expert settings and modify:
      - **Buffer mode**: All network filesystems (optimizes network streaming)
      - **Memory Size**: 512MB (allocates sufficient buffer for 4K Remuxes)
      - **Read Factor**: 10.00x (reduces buffering during playback)

   **Audio Settings** (Settings → Services → Audio)
    - Configure for lossless ATMOS passthrough:
      - **Audio Output Device**: ALSA:AML-AUGESOUND, HDMI Multi Ch PCM
      - **Number of Channels**: 7.1
      - **Output Configuration**: Best Match
      - **Keep Audio Device Alive**: Always (prevents audio device reinitialization)
      - **Enable "Audio Passthrough"**: Enabled
      - **Passthrough Output Device**: ALSA:AML-AUGESOUND, HDMI
      - **Enable all audio codecs**: AC3, E-AC3, DTS, TrueHD, DTS-HD (for Dolby Atmos/DTS:X support)

   **Display Settings** (Settings → Services → Display)
    - Turn on expert settings and modify:
      - **Enable "Disable Noise Reduction"**: Enabled (preserves original video quality)
      - **Dolby Vision LED Mode**: TV-Led (optimizes DV tone mapping)

   **(Optional) Debug Logging** (Settings → Services → Logging)
    - **Enable Debug logging**: For troubleshooting only (disable after resolving issues as it consumes CPU)

   ##### System Configuration

   **Network Settings** (Settings → CoreELEC → Network)
    - **Turn off wireless connection** (wired Ethernet ensures stable streaming for high-bitrate content)

   **Update Settings** (Settings → CoreELEC → Updates)
    - **Turn off all settings** (prevents automatic updates that may cause instability)

   ##### Jellyfin Integration

    - Install [Jellyfin](https://jellyfin.org/docs/general/clients/kodi/#embedded-devices-android-tv-firestick-and-other-tv-boxes)
    and navigate the GUI to add all libraries.
    - Shutdown the device. Connect it to Dolby Vision display or soundbar with passthrough capabilities. Ensure a wired
      LAN connection as well.

   ##### Playback Verification

    - Movies which are in Dolby Vision 7.6 with FEL should work now. There might be a few frame drops for a few seconds
      while the TV display switches between SDR to Dolby Vision.
      - **Workaround**: Rewind the movie to the beginning. It should play perfectly as the display has already switched
        to the desired mode.

### 5. 🔒 Security Architecture

The security framework is built on multiple layers of protection:

#### Transport Security

- 🛡️ **SSL/TLS Implementation**
  - Automated certificate management
  - Modern TLS protocols only
  - Perfect Forward Secrecy
  - OCSP stapling

#### Access Control

- 🔑 **Authentication Strategy**
  - Multi-factor capability
  - Role-based access control
  - Session management
  - Brute force protection

#### Network Security

- 🌐 **Network Policies**
  - Inter-service communication control
  - Namespace isolation
  - Egress traffic filtering
  - Pod security policies

#### Secrets Management

- 🤫 **Secure Configuration**
  - Encrypted secrets storage
  - Runtime injection
  - Rotation policies
  - Least privilege principle

#### DNS Security

- ☁️ **Cloudflare Integration**
  - DDoS protection
  - WAF capabilities
  - DNS-based authentication
  - Proxy protection

> 💡 **Security Philosophy**: Defense in depth with multiple security layers
> working together to protect services and data.

### 6. ⚙️ Configuration Management

The configuration system follows modern GitOps principles:

#### Base Configuration

```yaml
Structure:
  base/:
    # Core service definitions
    htpc/     # Media services
    infra/    # Infrastructure components
    utils/    # Utility services
```

#### Environment Overlays

```yaml
Structure:
  overlays/:
    argocd/     # ArgoCD specific configurations
    environment/
      staging-infra/      # Development infrastructure
      staging-ingress/    # Development ingress
      production-infra/   # Production infrastructure
      production-ingress/ # Production ingress
    htpc/       # Media service overlays
    infra/      # Infrastructure overlays
    utils/      # Utility service overlays
```

#### Configuration Principles

1. **Immutability**
   - All changes version controlled
   - No direct cluster modifications
   - Automated rollback capability
   - Change history tracking

2. **Separation of Concerns**
   - Environment-specific settings isolated
   - Shared configurations in base
   - Clear dependency management
   - Modular design

3. **Validation**
   - Schema validation
   - Configuration testing
   - Security scanning
   - Drift detection

4. **Secret Management**
   - Encrypted at rest
   - Environment separation
   - Access auditing
   - Automated rotation

> 💡 **Configuration Strategy**: The configuration management system is designed
> to be maintainable, secure, and scalable while following GitOps best practices.

### 7. 🔄 CI/CD Architecture

The continuous integration and deployment pipeline is designed for reliability and automation:

#### Pipeline Stages

| Stage | Tool | Purpose | Implementation Details |
| ------- | ------ | --------- | ---------------------- |
| Lint | yamllint | YAML Validation | - Syntax checking<br>- Style enforcement<br>- Custom rules |
| Test | kubeconform | Manifest Validation | - Schema validation<br>- Version checking<br>- Resource validation |
| Build | kustomize | Generate install.yaml | - Overlay composition<br>- Resource generation<br>- Configuration merging |
| Deploy | kubectl | Apply to Cluster | - Rolling updates<br>- Health checking<br>- Rollback capability |

#### Pipeline Design Principles

1. **Automation First**
   - Zero-touch deployment
   - Automated testing
   - Self-healing capabilities
   - Continuous verification

2. **Quality Gates**
   - Syntax validation
   - Security scanning
   - Configuration testing
   - Resource validation

3. **Deployment Strategy**
   - Rolling updates
   - Canary deployments
   - Blue-green capability
   - Automated rollbacks

4. **Monitoring Integration**
   - Deployment metrics
   - Performance tracking
   - Error reporting
   - Alert generation

#### Automated Dependency Management

The platform uses **Renovate Bot** for automated dependency updates:

**Features:**

- 🤖 Automated dependency updates for Docker images, Helm charts, and CRDs
- 🔄 Auto-merge for minor and patch updates
- 📝 Custom regex managers for various file patterns
- 🔐 Support for multiple container registries (ghcr.io, docker.io)
- 🎯 Intelligent version detection and tracking

**Managed Components:**

- Docker images in Kubernetes manifests
- Helm chart versions
- CRD URLs from GitHub releases
- Pre-commit hook versions
- GitHub Action versions

**Configuration Highlights:**

```yaml
Auto-merge: minor & patch updates
Timezone: Europe/Berlin
Labels: dependencies, automated
Timeout: 60s for container registries
```

> 💡 **Automation Philosophy**: Renovate keeps the platform up-to-date with
> minimal manual intervention while maintaining stability through smart
> auto-merge policies and comprehensive testing.

### 8. 🛠️ Utility Applications

#### 🏠 Homepage

- Dashboard Widgets
- System Metrics

#### 📸 Immich

- Mobile Apps
- ML Features
- Location Tracking

#### 📝 Tandoor

- Recipe Book
- Shopping Lists
- Multi-user Support

### 9. 🔄 GitOps with ArgoCD

```yaml
Features:
- Auto-sync
- Live View
- Drift Detection
- Health Monitoring
```

### 10. 📊 Observability Architecture

The monitoring system is built on three pillars: metrics, logs, and traces.

#### Metrics Collection

| Component | Purpose | Key Metrics |
| ----------- | --------- | ------------- |
| Prometheus | Time-series DB | - Resource utilization<br>- Application metrics<br>- Service health |
| Exportarr | Media Stats | - Download status<br>- Queue metrics<br>- Quality stats |
| Node Exporter | System Metrics | - Hardware stats<br>- System load<br>- Network usage |
| ServiceMonitor | Service Discovery | - ArgoCD<br>- Scraparr<br>- cert-manager<br>- CNPG operator |

#### Log Management

| Component | Role | Features |
| ----------- | ------ | ---------- |
| Loki | Log Aggregation | - Label-based queries<br>- Log correlation<br>- Real-time tailing |
| Alloy | Log Collection | - Service discovery<br>- Label extraction<br>- Pipeline processing |

#### Tracing

| Component | Purpose | Capabilities |
| ----------- | --------- | ------------- |
| Jaeger | Request Tracing | - Latency analysis<br>- Error tracking<br>- Dependency mapping |

#### Visualization & Alerting

Pre-configured Grafana dashboards for comprehensive monitoring:

| Dashboard | Focus | Features |
| ----------- | ------- | ---------- |
| ArgoCD | GitOps Operations | - Application sync status<br>- Deployment health<br>- API activity |
| cert-manager | Certificate Management | - Certificate expiry<br>- Renewal status<br>- Issuer health |
| Kubernetes | Cluster Health | - Resource usage<br>- Node status<br>- Pod metrics |
| Loki | Log Aggregation | - Log volume<br>- Error rates<br>- Query performance |
| Scraparr | Media Automation | - Service health<br>- Request metrics<br>- Error tracking |
| HTPC | Media Services | - Arr stack metrics<br>- Error Log<br>- Resource limit recomendations |
| System Health | Infrastructure | - Resource usage<br>- Node status<br>- Network stats |
| Media Status | Content | - Download progress<br>- Library status<br>- Quality metrics |
| Application | Services | - Response times<br>- Error rates<br>- Request volume |

> 💡 **Observability Philosophy**: Complete system visibility with correlation
> across metrics, logs, and traces for rapid problem resolution.

## 🚀 Deployment Guide

1. **Prerequisites**
   - ✅ k3s cluster
   - ✅ kubectl configured
   - ✅ Git installed

2. **Setup Steps**

   ```bash
   # 1. Clone repository
   git clone <repo-url>

   # 2. Configure environment
   cd my-homelab
   ./scripts/bootstrap.sh

   # 3. Kickstart your ArgoCD installation
   ./scripts/kickstart.sh

   # 4. Login to ArgoCD via the password from the CLI
   ```

3. **Available Scripts**

  | Script | Purpose |
  | -------- | --------- |
  | 🛠️ bootstrap.sh | Install essential libraries in a new Ubuntu VM |
  | ✅ validate.sh | Config Check |
  | 🚀 deploy.sh | Deployment |
  | 💣 nuke.sh | Reset Cluster |
  | ⚡ kickstart.sh | Install ArgoCD and deploy services |
  | 🛠️ update-manifests.sh | Kustomize build Script |
  | 🔐 encrypt-secrets.sh | Encode secrets in the repo |

## 👏 Credits

This project builds upon [htk8s](https://github.com/fabito/htk8s), enhanced with additional features and modern tooling.
