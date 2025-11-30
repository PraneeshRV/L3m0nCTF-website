### Docker Challenges

Containerized challenge management for CTFd. Multi-server deployment with dynamic container provisioning.

`CTFd v3.8.0` Tested

#### Features

Multi-server architecture with load balancing
Dynamic container provisioning and cleanup
Domain mapping for clean URLs
TLS/SSL support for secure communication
Health monitoring and failover
Per-team container isolation

#### Setup

```
docker compose up --build
```

Plugin loads automatically. Configure via `/admin/docker_config`

#### Configuration

Add Docker servers in admin panel:
- Hostname: Docker daemon endpoint
- Domain: Optional subdomain mapping
- TLS: Certificate-based authentication
- Repositories: Allowed Docker registries

#### Database Tables

`docker_config` - Server configuration
`docker_challenge_tracker` - Active containers
`docker_challenge` - Challenge settings

#### Admin Endpoints

- `/admin/docker_config` - Server management
- `/admin/docker_status` - Container monitoring
- `/api/v1/container` - Container API

```
Author: Abu
```