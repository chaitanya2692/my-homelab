# 🏠 My Kubernetes Homelab Platform

[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue)](https://chaitanya2692.github.io/my-homelab/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![k3s](https://img.shields.io/badge/k3s-latest-orange)](https://k3s.io/)

> 🚀 A modern, cloud-native homelab platform powered by Kubernetes

![System Architecture](system_design.png)

A comprehensive Kubernetes-based homelab running on [k3s](https://k3s.io/), featuring enterprise-grade
infrastructure, personal cloud services, media automation, and full observability. Built with GitOps
principles and Infrastructure as Code.

## 📚 Documentation

**➡️ [View Full Documentation](https://chaitanya2692.github.io/my-homelab/)**

The complete documentation includes:

- **[Getting Started](https://chaitanya2692.github.io/my-homelab/getting-started/)** - Installation and deployment guides
- **[Architecture](https://chaitanya2692.github.io/my-homelab/architecture/)** - System design and components
- **[Services](https://chaitanya2692.github.io/my-homelab/services/)** - Service catalog and configuration
- **[Configuration](https://chaitanya2692.github.io/my-homelab/configuration/)** - Configuration management
- **[Reference](https://chaitanya2692.github.io/my-homelab/reference/)** - Technical reference

## ✨ Platform Capabilities

- 🏗️ **Enterprise-Grade Infrastructure** - Production-ready Kubernetes with HA options
- ☁️ **Personal Cloud Services** - Nextcloud, Immich, Tandoor
- 🎬 **Media Automation** - Complete *arr stack with Jellyfin
- 🔒 **Zero-Trust Security** - TLS everywhere, network policies, secrets management
- 🔄 **GitOps Deployment** - ArgoCD with automated dependency updates (Renovate)
- 📊 **Full Observability** - Prometheus, Grafana, Loki, Jaeger with pre-configured dashboards
- 🎛️ **Advanced Networking** - Traefik ingress, MetalLB load balancer, cert-manager

## 🚀 Quick Start

```bash
# Prerequisites: k3s cluster, kubectl, git

# 1. Clone repository
git clone https://github.com/chaitanya2692/my-homelab.git
cd my-homelab

# 2. Bootstrap environment (Ubuntu/Debian)
./scripts/bootstrap.sh

# 3. Deploy platform with ArgoCD
./scripts/kickstart.sh

# 4. Access ArgoCD
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

For detailed instructions, see the [Installation Guide](https://chaitanya2692.github.io/my-homelab/getting-started/installation/).

## 🧩 Core Services

| Category | Services |
| -------- | -------- |
| **Infrastructure** | k3s, ArgoCD, Traefik, cert-manager, MetalLB |
| **Observability** | Prometheus, Grafana, Loki, Jaeger, Alloy |
| **Personal Cloud** | Nextcloud, Homepage, Immich, Tandoor |
| **Media** | Jellyfin, Sonarr, Radarr, Prowlarr, Transmission |
| **Data Layer** | CloudNativePG, Redis, Valkey |

View the complete [Service Catalog](https://chaitanya2692.github.io/my-homelab/services/).

## 📖 Key Documentation

- **[Architecture Overview](https://chaitanya2692.github.io/my-homelab/architecture/overview/)** - System
  design and principles
- **[Hardware Setup](https://chaitanya2692.github.io/my-homelab/services/hardware-setup/)** - Optimal media
  playback configuration
- **[Configuration Management](https://chaitanya2692.github.io/my-homelab/architecture/configuration-management/)**
  \- GitOps with Kustomize
- **[Scripts Reference](https://chaitanya2692.github.io/my-homelab/getting-started/scripts-reference/)** -
  Automation scripts

## 🛠️ Available Scripts

| Script | Purpose |
| ------ | ------- |
| `bootstrap.sh` | Install dependencies on Ubuntu/Debian |
| `kickstart.sh` | Deploy ArgoCD and all services |
| `validate.sh` | Validate manifests before deployment |
| `deploy.sh` | Manual deployment (without ArgoCD) |
| `update-manifests.sh` | Build Kustomize manifests |
| `encrypt-secrets.sh` | Manage secrets encoding |
| `nuke.sh` | Reset cluster (destructive) |

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run validation: `./scripts/validate.sh`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Credits

This project builds upon [htk8s](https://github.com/fabito/htk8s), enhanced with additional features and
modern tooling.

---

**📚 [Read the Full Documentation](https://chaitanya2692.github.io/my-homelab/)** for comprehensive
guides, architecture details, and configuration references.
