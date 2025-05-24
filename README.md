# 🏠 My Kubernetes Homelab Platform

![htk8s diagrams](system_design.png)

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

- 📊 **Enterprise Monitoring**
  - Full observability stack
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
|------|---------|-------------|
| <img src="https://k3s.io/img/k3s-logo-light.svg" alt="k3s logo" height="40"> | [k3s](https://k3s.io/) | Lightweight Kubernetes |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/argo-cd.svg" alt="ArgoCD logo" height="40"> | [ArgoCD](https://argoproj.github.io/cd/) | GitOps Deployment |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/traefik.svg" alt="Traefik logo" height="40"> | [Traefik](https://traefik.io/) | Ingress Controller |
| <img src="https://raw.githubusercontent.com/cert-manager/cert-manager/master/logo/logo.svg" alt="cert-manager logo" height="40"> | [cert-manager](https://cert-manager.io/) | Certificate Management |
| <img src="https://raw.githubusercontent.com/metallb/metallb/main/website/static/images/logo/metallb-blue.svg" alt="MetalLB logo" height="40"> | [MetalLB](https://metallb.universe.tf/) | Load Balancer |

### 🔭 Observability

| Logo | Service | Description |
|------|---------|-------------|
| <img src="https://prometheus.io/assets/prometheus_logo_grey.svg" alt="Prometheus logo" height="40"> | [Prometheus](https://prometheus.io/) | Metrics Collection |
| <img src="https://raw.githubusercontent.com/grafana/grafana/main/public/img/grafana_icon.svg" alt="Grafana logo" height="40"> | [Grafana](https://grafana.com/) | Visualization |
| <img src="https://grafana.com/static/img/logos/logo-loki.svg" alt="Loki logo" height="40"> | [Loki](https://grafana.com/oss/loki/) | Log Aggregation |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/jaeger.svg" alt="Jaeger logo" height="40"> | [Jaeger](https://www.jaegertracing.io/) | Distributed Tracing |

### ☁️ Personal Cloud

| Logo | Service | Description |
|------|---------|-------------|
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/nextcloud.svg" alt="Nextcloud logo" width="40"> | [Nextcloud](https://nextcloud.com/) | File Sync & Share |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/png/homepage.png" alt="Homepage logo" height="40"> | [Homepage](https://gethomepage.dev/) | Service Dashboard |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/immich.svg" alt="Immich logo" height="40"> | [Immich](https://immich.app/) | Photo Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/tandoor-recipes.svg" alt="Tandoor logo" height="40"> | [Tandoor](https://tandoorrecipes.com/) | Recipe Management |

### 🎬 Media Services

| Logo | Service | Description |
|------|---------|-------------|
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/jellyfin.svg" alt="Jellyfin logo" height="40"> | [Jellyfin](https://jellyfin.org/) | Media Streaming |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/sonarr.svg" alt="Sonarr logo" height="40"> | [Sonarr](https://sonarr.tv/) | TV Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/radarr.svg" alt="Radarr logo" height="40"> | [Radarr](https://radarr.video/) | Movie Management |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/prowlarr.svg" alt="Prowlarr logo" height="40"> | [Prowlarr](https://prowlarr.com/) | Index Management |

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

#### 🚦 Traefik (v34.4.0)

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

#### 🏗️ MetalLB (v0.14.9)

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

#### 🔐 cert-manager (v1.17.1)

- 🎯 Let's Encrypt Integration
- ☁️ Cloudflare DNS-01 Challenge
- 🌟 Wildcard Certificates (*.my-homelab.party)

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
|-----------|-----|------|---------|---------------------|
| HTPC | htpc-pvc | Shared | Media & App Data | High throughput, large files |
| Infra | grafana-data-pvc | 5GB | Dashboards | Fast random access |
| | jaeger-data-pvc | 10GB | Tracing | High write frequency |
| | promtail-positions-pvc | 1GB | Logging | Sequential writes |
| Utils | immich-library-pvc | 20GB | Photos/Videos | Mixed IO patterns |
| | immich-redis-pvc | 5GB | Cache | In-memory performance |
| | immich-ml-cache-pvc | 10GB | ML Models | Read-optimized |
| | nextcloud-pvc | 31GB | Files | Mixed workload |
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

   ```mermaid
   graph TD
     A[Client Request] --> B[Format Check]
     B --> C[Direct Play?]
     C -->|Yes| D[Direct Stream]
     C -->|No| E[Transcode]
   ```

> 💡 **Workflow Design**: The media management workflow is designed to be
> fully automated while maintaining high quality standards and optimal
> resource usage.

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

    # Shared resources
    common/   # Common configurations
    secrets/  # Secret definitions
```

#### Environment Overlays

```yaml
Structure:
  overlays/:
    staging/    # Development configurations
      htpc/     # Media service overrides
      infra/    # Infrastructure overrides
      utils/    # Utility overrides

    production/ # Production configurations
      htpc/     # Production media settings
      infra/    # Production infrastructure
      utils/    # Production utility settings
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
|-------|------|---------|----------------------|
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

### 8. 🛠️ Utility Applications

#### 🏠 Homepage

- 📊 Dashboard Widgets
- 📈 System Metrics
- 🐳 Docker Integration

#### 📸 Immich

- 📱 Mobile Apps
- 🤖 ML Features
- 📍 Location Tracking

#### 📝 Tandoor

- 📚 Recipe Book
- 🛒 Shopping Lists
- 👥 Multi-user Support

### 9. 🔄 GitOps with ArgoCD

```yaml
Features:
- 🔄 Auto-sync
- 👀 Live View
- 🚨 Drift Detection
- 📊 Health Monitoring
```

### 10. 📊 Observability Architecture

The monitoring system is built on three pillars: metrics, logs, and traces.

#### Metrics Collection

| Component | Purpose | Key Metrics |
|-----------|---------|-------------|
| Prometheus | Time-series DB | - Resource utilization<br>- Application metrics<br>- Service health |
| Exportarr | Media Stats | - Download status<br>- Queue metrics<br>- Quality stats |
| Node Exporter | System Metrics | - Hardware stats<br>- System load<br>- Network usage |

#### Log Management

| Component | Role | Features |
|-----------|------|----------|
| Loki | Log Aggregation | - Label-based queries<br>- Log correlation<br>- Real-time tailing |
| Promtail | Log Collection | - Service discovery<br>- Label extraction<br>- Pipeline processing |

#### Distributed Tracing

| Component | Purpose | Capabilities |
|-----------|---------|-------------|
| Jaeger | Request Tracing | - Latency analysis<br>- Error tracking<br>- Dependency mapping |

#### Visualization & Alerting

| Dashboard | Focus | Features |
|-----------|-------|----------|
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
   |--------|---------|
   | 🔧 bootstrap.sh | Initial Setup |
   | ✅ validate.sh | Config Check |
   | 🔄 deploy.sh | Deployment |
   | 🗑️ nuke.sh | Cleanup |

## 👏 Credits

This project builds upon [htk8s](https://github.com/fabito/htk8s), enhanced with additional features and modern tooling.
