# Data Layer Services

Database and caching services that power the platform's applications.

## Service Overview

| Logo | Service | Description | Version |
| ------ | --------- | ------------- | --------- |
| <img src="https://cloudnative-pg.io/images/hero_image.png" alt="CNPG logo" height="40"> | [CloudNativePG](https://cloudnative-pg.io/) | PostgreSQL Operator | Latest |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/valkey.svg" alt="Valkey logo" height="40"> | [Valkey](https://valkey.io/) | Caching Layer (Immich) | (via Immich chart) |
| <img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/refs/heads/main/svg/redis.svg" alt="Redis logo" height="40"> | [Redis](https://redis.io/) | Caching Layer (Nextcloud) | Latest |

## CloudNativePG

[CloudNativePG](https://cloudnative-pg.io/) is a Kubernetes operator for PostgreSQL.

### Features

- **High Availability**: Automated failover
- **Backup/Restore**: Point-in-time recovery
- **Monitoring**: Prometheus metrics
- **Declarative**: Kubernetes-native configuration
- **Streaming Replication**: Built-in replication

### Configuration

CNPG Cluster resources define instance count, PostgreSQL parameters, bootstrap configuration, storage requirements,
and monitoring settings.

??? example "View CNPG Cluster configuration"
    See `base/utils/cnpg/` directory for cluster configurations.

### Usage

Applications connect using standard PostgreSQL connection strings pointing to the cluster read-write service endpoint.

### Monitoring

- Prometheus metrics exported
- Dashboard in Grafana
- Backup status tracking
- Replication lag monitoring

## Valkey

[Valkey](https://valkey.io/) is a high-performance caching layer (Redis fork).

### Valkey Usage

Primary caching layer for Immich:

- Image thumbnails
- ML model cache
- Session storage
- Query results

### Valkey Configuration

Valkey pods run the Valkey container with persistent storage mounted for data persistence.

### Valkey Storage

- PVC: 5GB
- Persistence enabled
- Regular snapshots

## Redis

[Redis](https://redis.io/) is an in-memory data structure store.

### Redis Usage

Caching specifically for Nextcloud:

- File locking
- Session storage
- Local cache
- Distributed cache

### Redis Configuration

Redis runs as a standard Kubernetes Deployment with:

- Single replica (non-HA setup)
- Redis 8.4.0 image
- Port 6379 exposed for connections
- Persistent volume mounted at `/data`

### Redis Storage

- PVC: 1GB (Nextcloud)
- Persistence enabled
- Data stored in /data mount

## Database Best Practices

### Performance

- **Connection pooling**: Use PgBouncer
- **Indexing**: Create appropriate indexes
- **Vacuuming**: Regular maintenance
- **Monitoring**: Track query performance

### Backup

- **Automated backups**: Daily backups
- **Point-in-time recovery**: WAL archiving
- **Backup testing**: Regular restore tests
- **Off-site storage**: External backup location

### Security

- **Strong passwords**: Complex credentials
- **Network policies**: Restrict access
- **Encryption**: TLS connections
- **Least privilege**: Minimal permissions

### Database Monitoring

- **Connection counts**: Monitor active connections
- **Query performance**: Slow query log
- **Resource usage**: CPU, memory, disk I/O
- **Replication lag**: For HA setups

## Troubleshooting

### PostgreSQL Issues

```bash
# Check cluster status
kubectl get cluster -n utils

# View pod logs
kubectl logs -n utils postgres-cluster-1

# Check replication status
kubectl exec -n utils postgres-cluster-1 -- psql -U postgres -c "SELECT * FROM pg_stat_replication;"

# Check database size
kubectl exec -n utils postgres-cluster-1 -- psql -U postgres -c "SELECT pg_database_size('dbname');"
```

### Redis/Valkey Issues

```bash
# Check pod status
kubectl get pods -n utils -l app=redis

# View logs
kubectl logs -n utils redis-0

# Test connection
kubectl exec -n utils redis-0 -- redis-cli ping

# Check memory usage
kubectl exec -n utils redis-0 -- redis-cli info memory
```

### Connection Issues

```bash
# Test database connection
kubectl run -it --rm psql --image=postgres:alpine --restart=Never -- \
  psql -h postgres-cluster-rw -U app -d app

# Test Redis connection
kubectl run -it --rm redis-cli --image=redis:alpine --restart=Never -- \
  redis-cli -h redis PING
```

## Related Documentation

- [Architecture: Storage](../architecture/storage.md)
- [Services: Personal Cloud](personal-cloud.md)
- [Configuration](../configuration/index.md)
