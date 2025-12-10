# Reference

Technical reference documentation for the homelab platform.

## Reference Documentation

<div class="grid cards" markdown>

- :material-database:{ .lg .middle } [__Storage Reference__](storage-reference.md)

    ---

    Complete PVC specifications and capacity planning

- :material-network:{ .lg .middle } [__Network Reference__](network-reference.md)

    ---

    IP addressing, ports, and load balancer configuration

- :material-script:{ .lg .middle } [__Scripts API__](scripts-api.md)

    ---

    Detailed automation script documentation

</div>

## Quick Reference

### Common Commands

```bash
# Check cluster status
kubectl get nodes
kubectl get pods -A

# Check ArgoCD applications
kubectl get applications -n argocd

# View service logs
kubectl logs -n <namespace> <pod-name>

# Port forward to service
kubectl port-forward -n <namespace> svc/<service> <local-port>:<remote-port>
```

### Common Paths

- __Storage__: `/opt/local-path-provisioner`
- __Kubeconfig__: `/etc/rancher/k3s/k3s.yaml`
- __k3s service__: `/etc/systemd/system/k3s.service`

### Common Ports

- __HTTP__: 80
- __HTTPS__: 443
- __Kubernetes API__: 6443
- __ArgoCD__: 8080 (port-forward)
- __Grafana__: 3000 (port-forward)

## Related Documentation

- [Architecture](../architecture/index.md)
- [Getting Started](../getting-started/index.md)
- [Configuration](../configuration/index.md)
