# CI/CD Architecture

The continuous integration and deployment pipeline ensures reliable and automated delivery of infrastructure changes.

## Pipeline Overview

The CI/CD pipeline is designed for reliability, automation, and GitOps principles.

## Pipeline Stages

| Stage | Tool | Purpose | Implementation Details |
| ----- | ---- | ------- | ---------------------- |
| Lint | yamllint | YAML Validation | - Syntax checking<br>- Style enforcement<br>- Custom rules |
| Test | kubeconform | Manifest Validation | - Schema validation<br>- Version checking<br>- Resource validation |
| Build | kustomize | Generate install.yaml | - Overlay composition<br>- Resource generation<br>- Configuration merging |
| Deploy | kubectl | Apply to Cluster | - Rolling updates<br>- Health checking<br>- Rollback capability |

## Pipeline Design Principles

### 1. Automation First

#### Zero-Touch Deployment

- Automatic deployment on Git push
- No manual intervention required
- Consistent deployment process
- Reduced human error

#### Automated Testing

- Syntax validation
- Schema validation
- Security scanning
- Configuration testing

#### Self-Healing Capabilities

- Automatic rollback on failure
- Health check monitoring
- Pod restart on crash
- ArgoCD auto-sync

#### Continuous Verification

- Post-deployment health checks
- Metrics monitoring
- Log analysis
- Alert generation

### 2. Quality Gates

#### Syntax Validation

Use yamllint with a configuration file to validate YAML syntax and enforce style rules across base and overlay directories.

#### Configuration Testing

Validate Kubernetes resource schemas using kubeconform in strict mode to catch configuration errors.

#### Resource Validation

Use kubectl's server-side dry-run to validate resources against the actual cluster API.

### 3. Deployment Strategy

#### Recreate Strategy

Most deployments in this platform use the `Recreate` strategy, which:

- Terminates all existing pods before creating new ones
- Ensures only one version runs at a time
- Prevents resource conflicts for stateful applications
- Suitable for applications requiring exclusive access to persistent volumes

!!! note "Strategy Choice"
    The Recreate strategy is used for stateful applications like Tandoor, media services, and utilities
    that require exclusive access to persistent storage. This ensures data consistency and prevents
    file locking issues.

#### Automated Rollbacks

Kubernetes Deployments support automatic rollbacks by maintaining revision history (default: 10 revisions).
Rollback can be triggered manually using `kubectl rollout undo`.

### 4. Monitoring Integration

#### Deployment Metrics

- Deployment duration
- Success/failure rate
- Rollback frequency
- Resource utilization

#### Performance Tracking

- Response time trends
- Error rate changes
- Resource consumption
- User impact metrics

#### Error Reporting

- Deployment failures
- Application errors
- Infrastructure issues
- Security violations

#### Alert Generation

- Slack notifications
- Email alerts
- PagerDuty integration
- Webhook triggers

## Automated Dependency Management

The platform uses **Renovate Bot** for automated dependency updates.

### Features

🤖 **Automated Updates**

- Docker images in Kubernetes manifests
- Helm chart versions
- CRD URLs from GitHub releases
- Pre-commit hook versions
- GitHub Action versions

🔄 **Auto-Merge Capabilities**

- Minor and patch updates auto-merge
- Major updates require manual review
- Configurable merge strategies
- CI validation before merge

📝 **Custom Regex Managers**

- Extract versions from various formats
- Custom update patterns
- Flexible version detection

🔐 **Multi-Registry Support**

- GitHub Container Registry (ghcr.io)
- Docker Hub (docker.io)
- Quay.io
- Custom registries

🎯 **Intelligent Tracking**

- Follow semantic versioning
- Respect version constraints
- Track release notes
- Group related updates

### Renovate Configuration

Renovate is configured to:

- Auto-merge minor and patch updates
- Require manual review for major updates
- Use custom regex managers for version extraction
- Respect rate limits and schedule constraints

??? example "View renovate.json"
    --8<-- "renovate.json"

### Managed Components

=== "Docker Images"

    Image tags in Kubernetes manifests are automatically updated to latest versions.

=== "Helm Charts"

    Chart dependencies and versions are tracked and updated.

=== "CRDs"

    CRD URLs from GitHub releases are automatically updated to new versions.

!!! note "Automation Philosophy"
    Renovate keeps the platform up-to-date with minimal manual intervention while
    maintaining stability through smart auto-merge policies and comprehensive testing.

## GitOps with ArgoCD

### Core Features

ArgoCD provides:

- Automatic sync from Git
- Live application state view
- Configuration drift detection
- Health status monitoring
- One-click rollback
- Multi-cluster management

### Application Configuration

ArgoCD Applications define:

- Source repository and path
- Target cluster and namespace
- Sync policies (automated, pruning, self-heal)
- Retry logic with exponential backoff

??? example "View ArgoCD Application"
    --8<-- "argocd/app/application.yaml"

### Sync Strategies

#### Automatic Sync

The platform uses ArgoCD's automatic sync policy:

- **Auto-sync**: Automatically syncs when Git changes are detected
- **Auto-prune**: Removes resources deleted from Git
- **Self-healing**: Not enabled in current configuration

#### Sync Options

Configured sync options:

- `CreateNamespace=true`: Automatically creates target namespaces
- `ApplyOutOfSyncOnly=true`: Only syncs resources that are out of sync
- `ServerSideApply=true`: Uses server-side apply for better conflict resolution

#### Manual Sync

Manual sync is available through ArgoCD UI or CLI:

- Explicit sync trigger via UI or `argocd app sync`
- Review changes before applying
- Useful for controlled deployments

## Continuous Integration

### GitHub Actions Workflow

The platform uses GitHub Actions for continuous integration:

??? example "View Pull Request CI Workflow"
    --8<-- ".github/workflows/push.yml"

## Deployment Workflow

### Standard Deployment

    ```mermaid
    flowchart TD
        A[Developer commits changes] --> B[Create Pull Request]
        B --> C{CI Pipeline}
        C --> D[YAML Lint]
        C --> E[Markdown Lint]
        C --> F[Secret Detection]
        D --> G[Validate Manifests]
        E --> G
        G --> H[Test Kustomize Build]
        F --> H
        H --> I{All Checks Pass?}
        I -->|No| J[Fix Issues]
        J --> A
        I -->|Yes| K[Merge to main]
        K --> L[ArgoCD Detects Change]
        L --> M[ArgoCD Auto-Sync]
        M --> N[Apply CRDs]
        N --> O[Wait for CRDs Established]
        O --> P[Apply Resources]
        P --> Q[Health Checks]
        Q --> R{Healthy?}
        R -->|Yes| S[Deployment Complete]
        R -->|No| T[Manual Investigation]
    ```

1. **Developer commits changes**
2. **CI pipeline runs**
    - Lint YAML and Markdown
    - Validate schemas with kubeconform
    - Security scan with TruffleHog
    - Test kustomize build
3. **Merge to main branch**
4. **ArgoCD detects change**
5. **ArgoCD auto-syncs cluster**
6. **Resources applied** (CRDs first, then other resources)
7. **Health checks monitored**
8. **Deployment complete**

### Emergency Deployment

    ```mermaid
    flowchart TD
        A[Critical Issue Detected] --> B[Create Hotfix Branch]
        B --> C[Implement Fix]
        C --> D[Fast-Track PR Review]
        D --> E{CI Passes?}
        E -->|No| C
        E -->|Yes| F[Merge to main]
        F --> G[Manual ArgoCD Sync]
        G --> H[Monitor Closely]
        H --> I{Issue Resolved?}
        I -->|Yes| J[Document Incident]
        I -->|No| K[Rollback]
        K --> L[Investigate Further]
    ```

1. **Hotfix branch created**
2. **Fast-track review process**
3. **Merge to main**
4. **Manual ArgoCD sync** (if immediate deployment needed)
5. **Monitor closely** for issues
6. **Document incident** and post-mortem

### CI/CD Pipeline Flow

    ```mermaid
    flowchart LR
        A[Git Push] --> B{Event Type}
        B -->|Pull Request| C[Pull Request CI]
        B -->|Merge to main| D[Merge CI]

        C --> E[yaml-lint]
        C --> F[markdownlint]
        C --> G[detect-secrets]
        E --> H[validate]
        F --> H
        G --> I[test-build]
        H --> I

        D --> J[detect-secrets]

        I --> K[PR Approved]
        K --> L[Merge]
        L --> M[ArgoCD Auto-Sync]
    ```

## Related Documentation

- [Configuration Management](configuration-management.md) - GitOps details
- [Getting Started: Scripts](../getting-started/scripts-reference.md) - Automation scripts
