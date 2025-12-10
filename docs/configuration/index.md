# Configuration

Learn how to manage and customize your homelab deployment.

## Configuration Overview

The platform uses a layered configuration approach:

1. **Base Configurations**: Common settings for all environments
2. **Overlays**: Environment-specific customizations
3. **Secrets**: Sensitive data management

## Configuration Management

<div class="grid cards" markdown>

- :material-file-code:{ .lg .middle } [**Base Configurations**](base-configurations.md)

    ---

    Core service definitions and shared settings

- :material-layers:{ .lg .middle } [**Overlays**](overlays.md)

    ---

    Environment-specific customizations

- :material-lock:{ .lg .middle } [**Secrets**](secrets.md)

    ---

    Secure credential management

</div>

## Configuration Principles

### GitOps-Based

All configuration stored in Git as the single source of truth.

### Declarative

Desired state defined in YAML manifests.

### Environment Separation

Staging and production configurations isolated.

### Security First

Secrets encrypted and managed securely.

## Quick Links

- [Architecture: Configuration Management](../architecture/configuration-management.md)
- [Getting Started](../getting-started/index.md)
- [Services](../services/index.md)
