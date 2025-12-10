# Observability Stack

The observability stack provides comprehensive monitoring, logging, and tracing capabilities.

## Service Overview

| Logo | Service | Description | Version |
| ------ | --------- | ------------- | --------- |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/prometheus.svg" alt="Prometheus logo" height="40"> | [Prometheus](https://prometheus.io/) | Metrics Collection | Latest |
| <img src="https://raw.githubusercontent.com/grafana/grafana/main/public/img/grafana_icon.svg" alt="Grafana logo" height="40"> | [Grafana](https://grafana.com/) | Visualization | (kube-prometheus-stack) |
| <img src="https://grafana.com/static/img/logos/logo-loki.svg" alt="Loki logo" height="40"> | [Loki](https://grafana.com/oss/loki/) | Log Aggregation | Latest |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/jaeger.svg" alt="Jaeger logo" height="40"> | [Jaeger](https://www.jaegertracing.io/) | Distributed Tracing | Latest |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/alloy.svg" alt="Grafana Alloy logo" height="40"> | [Alloy](https://grafana.com/oss/alloy/) | OpenTelemetry Collector | Latest |

## Prometheus

Metrics collection and time-series database.

### Features

- Service discovery
- PromQL query language
- AlertManager integration
- Long-term storage

[Learn more →](../architecture/observability.md#metrics-collection)

## Grafana

Visualization and dashboard platform.

### Pre-configured Dashboards

- ArgoCD Operations
- cert-manager Status
- Kubernetes Cluster
- Loki Logs
- Scraparr Metrics
- HTPC Services
- System Health
- Media Status
- Application Metrics

### Access

```bash
kubectl port-forward -n infra svc/grafana 3000:80
```

Default: `admin` / `admin` (change on first login)

## Loki

Log aggregation system.

### Loki Features

- Label-based queries
- LogQL query language
- Integration with Grafana
- Efficient storage

## Jaeger

Distributed tracing platform.

### Jaeger Capabilities

- Request flow visualization
- Latency analysis
- Error tracking
- Service dependencies

## Alloy

OpenTelemetry collector for logs and traces.

### Alloy Features

- Log collection
- Trace collection
- Pipeline processing
- Service discovery

## Related Documentation

- [Architecture: Observability](../architecture/observability.md)
- [Configuration](../configuration/index.md)
