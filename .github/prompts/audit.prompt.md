# Documentation Audit and Update Prompt

This prompt guides AI agents to fact-check, update, and enhance technical documentation for the my-homelab project.

## Objective

Systematically audit and improve documentation files to ensure they:
1. Accurately reflect the actual codebase implementation
2. Remove unimplemented or aspirational features
3. Replace inline code examples with snippet references to actual files
4. Add visual diagrams (mermaid) for complex workflows
5. Update outdated paths, commands, and configurations

## Prerequisites

Before starting, the agent must:
- Have access to the entire workspace structure
- Be able to read files from all directories
- Understand the project structure (base/, overlays/, scripts/, docs/)
- Know the difference between base configurations and environment overlays

## Step-by-Step Process

### Phase 1: Discovery and Analysis

#### 1.1 Read the Target Documentation File
```
Read the entire documentation file from start to finish.
Note all claims, examples, configurations, and procedures mentioned.
```

#### 1.2 Create a Fact-Checking Checklist
For each section, identify:
- [ ] Configuration files or resources mentioned
- [ ] Commands or scripts referenced
- [ ] Directory paths and file locations
- [ ] Feature descriptions and capabilities
- [ ] Workflow descriptions
- [ ] Code examples (inline YAML, bash, etc.)
- [ ] Numeric values (IPs, ports, sizes, timeouts)

#### 1.3 Map Documentation Claims to Codebase
For each claim in the documentation:
1. **Locate the actual implementation** in the codebase
2. **Verify accuracy** by reading the actual file
3. **Note discrepancies** between docs and reality
4. **Identify missing features** (documented but not implemented)
5. **Find undocumented features** (implemented but not documented)

### Phase 2: Verification Strategies

#### 2.1 Configuration Verification
```bash
# For Kubernetes resources
grep_search: kind: <ResourceType>
file_search: **/<resource-name>*.yaml

# For specific configurations
grep_search: <config-key>: <value>
read_file: <discovered-file-path>

# For paths and directories
list_dir: <directory-path>
```

#### 2.2 Script and Command Verification
```bash
# For scripts mentioned in docs
read_file: scripts/<script-name>.sh

# Verify script arguments and behavior
grep_search: (query: "ENVIRONMENT=|ARG_NAME=", includePattern: "scripts/*.sh")

# Check for actual usage in CI/CD
read_file: .github/workflows/*.yml
```

#### 2.3 Value Verification Checklist

| Category | What to Check | How to Verify |
|----------|---------------|---------------|
| IP Addresses | MetalLB pool, service IPs | Read metallb config files |
| Storage Sizes | PVC requests | Read PVC definitions |
| Ports | Service ports, container ports | Read service and deployment files |
| Paths | Volume mount paths, storage paths | Read deployment and storageclass files |
| Versions | Image tags, chart versions | Read deployment files and values.yaml |
| Replicas | Deployment replicas | Read deployment specifications |
| Resource Limits | CPU/Memory limits | Read deployment specifications |
| Environment Variables | ENV vars in docs | Grep deployment files |

### Phase 3: Common Issues to Check

#### 3.1 Deployment Strategy Claims
- [ ] Does doc claim "RollingUpdate" but code uses "Recreate"?
- [ ] Are maxSurge/maxUnavailable mentioned but not configured?
- [ ] Are canary/blue-green deployments mentioned but not implemented?
- [ ] Is progressDeadlineSeconds mentioned but not set?

#### 3.2 Storage Path Issues
- [ ] Does doc reference old paths (e.g., `/opt/local-path-provisioner`)?
- [ ] Should paths be namespace-specific (e.g., `/opt/cluster/{namespace}`)?
- [ ] Are storageClass names correct?
- [ ] Is reclaim policy accurate (Delete vs Retain)?

#### 3.3 Security Feature Claims
- [ ] Are NetworkPolicies documented but only exist for specific namespaces?
- [ ] Is RBAC described generically but only implemented for specific services?
- [ ] Are securityContext features documented that aren't universally applied?
- [ ] Is secret management described accurately (SOPS vs plain secrets)?

#### 3.4 Networking Configuration
- [ ] Are IngressRoute examples from actual files or generic?
- [ ] Are middleware configurations documented from actual implementations?
- [ ] Are TLS configurations verified against actual Traefik config?
- [ ] Is the service mesh section describing future plans vs current reality?

#### 3.5 CI/CD Pipeline Accuracy
- [ ] Do GitHub Actions workflows match what's documented?
- [ ] Are all jobs and their dependencies correctly described?
- [ ] Are script names and arguments accurate?
- [ ] Are environment variables and secrets correctly documented?

### Phase 4: Update Strategies

#### 4.1 Replace Inline Code with Snippets

**Before:**
```markdown
### Configuration

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example
spec:
  type: LoadBalancer
```
```

**After:**
```markdown
### Configuration

??? example "View service configuration"
    --8<-- "../path/to/actual/file.yaml"
```

#### 4.2 Add Mermaid Diagrams

Identify sections that would benefit from visual diagrams:

**Workflow Sections:**
- Deployment workflows → Flowchart
- Request/response flows → Sequence diagram
- Component relationships → Architecture diagram
- State transitions → State diagram

**Diagram Templates:**

```markdown
### Deployment Flow
\`\`\`mermaid
flowchart TD
    A[Start] --> B[Step 1]
    B --> C{Decision}
    C -->|Yes| D[Success]
    C -->|No| E[Failure]
\`\`\`

### Request Flow
\`\`\`mermaid
sequenceDiagram
    participant Client
    participant Ingress
    participant Service
    Client->>Ingress: HTTPS Request
    Ingress->>Service: Forward
    Service->>Ingress: Response
    Ingress->>Client: HTTPS Response
\`\`\`

### Architecture
\`\`\`mermaid
graph TB
    subgraph "Layer 1"
        A[Component A]
    end
    subgraph "Layer 2"
        B[Component B]
        C[Component C]
    end
    A --> B
    A --> C
\`\`\`
```

#### 4.3 Update Factual Information

Create a multi_replace operation for all fixes:

```json
{
  "replacements": [
    {
      "explanation": "Fix storage path from generic to namespace-specific",
      "filePath": "/path/to/doc.md",
      "oldString": "... /opt/local-path-provisioner ...",
      "newString": "... /opt/cluster/{namespace} ..."
    },
    {
      "explanation": "Update deployment strategy to reflect actual implementation",
      "filePath": "/path/to/doc.md",
      "oldString": "... RollingUpdate strategy ...",
      "newString": "... Recreate strategy ..."
    }
  ]
}
```

#### 4.4 Remove Unimplemented Features

For features that are aspirational or planned but not implemented:

**Strategy 1: Remove entirely** (if purely speculative)
```markdown
## Service Mesh  ← DELETE SECTION
Future implementation of Istio/Linkerd...
```

**Strategy 2: Mark as future consideration** (if potentially valuable)
```markdown
## Future: Service Mesh

!!! note "Not Currently Implemented"
    Service mesh capabilities are under consideration for future implementation.
    Current architecture relies on namespace isolation and ingress control.
```

### Phase 5: Quality Assurance

#### 5.1 Verification Checklist
After making changes, verify:

- [ ] All file paths reference existing files
- [ ] All code snippets use `--8<--` syntax correctly
- [ ] All mermaid diagrams render correctly
- [ ] All numeric values match the codebase
- [ ] All commands use correct paths and arguments
- [ ] No broken internal links
- [ ] Consistent terminology throughout
- [ ] Proper markdown formatting

#### 5.2 Cross-Reference Check
Ensure documentation is consistent across files:

- [ ] Storage paths consistent across all docs
- [ ] IP addresses match across networking and reference docs
- [ ] Port numbers consistent in all mentions
- [ ] Version numbers align with actual deployments

#### 5.3 Documentation Standards

**Follow these conventions:**

1. **Use admonitions for important notes:**
   ```markdown
   !!! note "Title"
       Content

   !!! warning "Title"
       Content

   !!! info "Title"
       Content
   ```

2. **Use collapsible sections for code:**
   ```markdown
   ??? example "View configuration"
       --8<-- "../path/to/file.yaml"
   ```

3. **Use tables for structured data:**
   ```markdown
   | Column 1 | Column 2 | Column 3 |
   |----------|----------|----------|
   | Data     | Data     | Data     |
   ```

4. **Use code blocks with language tags:**
   ```markdown
   ```yaml
   # YAML content
   ```

   ```bash
   # Bash commands
   ```
   ```

## Target Files and Priority

### High Priority (Core Architecture)
- [x] `docs/architecture/cicd.md` - ✅ COMPLETED
- [x] `docs/architecture/networking.md` - ✅ COMPLETED
- [x] `docs/architecture/security.md` - ✅ COMPLETED
- [x] `docs/architecture/storage.md` - ✅ COMPLETED
- [x] `docs/architecture/observability.md` - ✅ COMPLETED
- [x] `docs/architecture/kubernetes-infrastructure.md` - ✅ COMPLETED
- [x] `docs/architecture/configuration-management.md` - ✅ COMPLETED

### Medium Priority (Getting Started)
- [ ] `docs/getting-started/installation.md`
- [ ] `docs/getting-started/prerequisites.md`
- [ ] `docs/getting-started/scripts-reference.md`

### Medium Priority (Configuration)
- [x] `docs/configuration/base-configurations.md` - ✅ COMPLETED
- [x] `docs/configuration/overlays.md` - ✅ COMPLETED
- [x] `docs/configuration/secrets.md` - ✅ COMPLETED

### Lower Priority (Services)
- [x] `docs/services/core-platform.md` - ✅ COMPLETED
- [x] `docs/services/media-services.md` - ✅ COMPLETED
- [x] `docs/services/personal-cloud.md` - ✅ COMPLETED
- [x] `docs/services/observability-stack.md` - ✅ COMPLETED (Previously)

### Lower Priority (Reference)
- [ ] `docs/reference/network-reference.md`
- [ ] `docs/reference/storage-reference.md`
- [ ] `docs/reference/scripts-api.md`

## Specific Patterns to Search For

### Pattern 1: Generic Storage Paths
```bash
grep_search:
  query: "/opt/local-path-provisioner"
  includePattern: "docs/**/*.md"
```
**Fix:** Replace with `/opt/cluster/{namespace}` or specific paths

### Pattern 2: Inline YAML Examples
```bash
grep_search:
  query: "```yaml\napiVersion:"
  includePattern: "docs/**/*.md"
  isRegexp: true
```
**Fix:** Replace with snippet references if file exists in codebase

### Pattern 3: Unverified Claims
Look for phrases like:
- "Uses RollingUpdate strategy"
- "Implements blue-green deployment"
- "NetworkPolicies control all traffic"
- "All containers run as non-root"

**Action:** Verify each claim against actual implementation

### Pattern 4: Outdated Commands
```bash
grep_search:
  query: "kubectl|kustomize|docker"
  includePattern: "docs/**/*.md"
```
**Fix:** Verify commands work with current cluster configuration

## Example Complete Audit Process

### Example: Auditing observability.md

#### Step 1: Read and Inventory
```
Read: docs/architecture/observability.md
Create inventory:
- Claims about Prometheus setup
- Grafana dashboard references
- Jaeger tracing configuration
- Loki logging setup
- Alert rules mentioned
```

#### Step 2: Verify Each Component
```
1. Prometheus
   - Check: base/infra/monitoring/values-prometheus.yaml
   - Verify: retention time, scrape intervals, storage size
   - Confirm: ServiceMonitor resources exist

2. Grafana
   - Check: base/infra/monitoring/values-grafana.yaml
   - Verify: dashboard provisioning, datasource configs
   - Confirm: PVC size matches docs

3. Jaeger
   - Check: base/infra/monitoring/values-jaeger.yaml
   - Verify: storage backend, retention
   - Confirm: integration with services

4. Loki
   - Check: base/infra/monitoring/values-loki.yaml
   - Verify: retention, storage configuration
   - Confirm: promtail or alloy configuration
```

#### Step 3: Find Inline Code
```
Search for inline configuration examples
Identify which ones can be replaced with file references
```

#### Step 4: Add Diagrams
```
Create diagrams for:
- Metrics collection flow (Prometheus scraping)
- Logging pipeline (Alloy → Loki → Grafana)
- Tracing flow (App → Jaeger)
- Alert routing (Prometheus → Alertmanager)
```

#### Step 5: Implement Changes
```
Use multi_replace_string_in_file for all fixes:
1. Replace inline configs with snippets
2. Fix storage paths
3. Update metric names if changed
4. Add mermaid diagrams
5. Remove unimplemented features
```

## Common Pitfalls to Avoid

1. **Don't assume consistency** - Verify every claim
2. **Don't use generic examples** - Reference actual files
3. **Don't skip verification** - Read the actual implementation files
4. **Don't make multiple sequential edits** - Batch with multi_replace
5. **Don't forget cross-references** - Update related documentation
6. **Don't ignore version specifics** - K8s versions, API versions matter
7. **Don't overlook environment differences** - staging vs production configs

## Success Criteria

A successfully audited document will:
✅ Have all claims verified against codebase
✅ Use snippet references instead of inline code (where applicable)
✅ Include mermaid diagrams for complex workflows
✅ Have accurate paths, IPs, ports, and sizes
✅ Clearly distinguish implemented vs planned features
✅ Maintain consistent formatting and style
✅ Cross-reference related documentation
✅ Include helpful admonitions and notes
✅ Be immediately usable by a new team member

## Execution Template

When given a file to audit, follow this template:

```
1. DISCOVERY
   - Read target file
   - List all verifiable claims
   - Identify code examples
   - Note workflow descriptions

2. VERIFICATION
   - For each claim, find implementation
   - Read actual configuration files
   - Note discrepancies
   - Identify missing features

3. PLANNING
   - List all required changes
   - Identify files for snippet references
   - Design mermaid diagrams
   - Group related changes

4. EXECUTION
   - Use multi_replace_string_in_file
   - Make all changes in one batch
   - Include clear explanations

5. VALIDATION
   - Review changes for accuracy
   - Check formatting
   - Verify snippet paths exist
   - Test mermaid syntax
```

## Agent Instructions

When executing this audit:

1. **Be thorough**: Check every claim, don't skip sections
2. **Be accurate**: Verify against actual code, not assumptions
3. **Be efficient**: Use parallel reads, batch edits
4. **Be clear**: Explain each change in the replacement explanation
5. **Be visual**: Add diagrams where they improve understanding
6. **Be consistent**: Follow the established patterns from completed files
7. **Be helpful**: Add notes and warnings for common issues

## Output Format

After completing an audit, provide:

```markdown
## Audit Summary: <filename>

### Issues Found
- [ ] Issue 1: Description
- [ ] Issue 2: Description
- [ ] Issue 3: Description

### Changes Made
1. **Category**: Brief description (N changes)
   - Specific change 1
   - Specific change 2

### Diagrams Added
- Diagram 1: Purpose
- Diagram 2: Purpose

### Verification
✅ All claims fact-checked
✅ All inline code replaced with snippets
✅ All paths updated
✅ All diagrams added
✅ Cross-references updated
```

---

**Note**: This prompt is designed to be used by AI agents with access to the full codebase and the ability to read, search, and edit files. It emphasizes accuracy, verification, and maintaining documentation quality standards.
