# Homelab Notes, Stacks, Configs, and Scripts

A comprehensive collection of homelab configurations, deployment stacks, Kubernetes manifests, and utility scripts for self-hosted infrastructure.

---

## 📁 Folder Structure

```
homelab/
├── Configs/           # Configuration files for various services
├── Images/            # Custom Docker images
├── kubernetes/        # Kubernetes manifests and deployment scripts
├── Notes/             # Documentation and setup guides
├── Scripts/           # Utility and automation scripts
└── Stacks/            # Docker/Podman compose files for services
```

---

## 🐳 Stacks

Docker Compose files for self-hosted services. Podman is preferred over Docker. All services are configured for local network access only (no TLS).

| Service | Port | Description |
|---------|------|-------------|
| **Heimdall** | 8080 | Application dashboard |
| **Portainer** | 8081 | Container management UI |
| **Filebrowser** | 8082 | Web-based file manager |
| **qBittorrent** | 8083 | Torrent client |
| **Jellyfin** | 8084 | Media server |
| **Pyload-NG** | 8085 | Download manager |
| **Filezilla** | 8086 | FTP client (web UI) |
| **Firefox** | 8087 | Browser in container |
| **Kavita** | 8093 | Digital library |
| **Immich** | 8097 | Photo management |
| **NFS** | 2049 | Network file sharing |

### Additional Services

- **Webservers**: Caddy, Nginx Proxy Manager, Traefik configurations
- **Media**: Dim, Stump, Komga (comic/manga readers)
- **Networking**: Pihole (DNS), Twingate (VPN)
- **Cloud**: Nextcloud, Code-Server

---

## ☸️ Kubernetes

Manifests and scripts for K3s cluster management.

| File | Purpose |
|------|---------|
| `rancher_deploy.sh` | Automated Rancher + cert-manager installation |
| `nfs_storage_class.yaml` | NFS CSI StorageClass configuration |
| `websurfx.yaml` | WebSurfX search engine deployment |
| `manifests/kafka.yaml` | Apache Kafka deployment |

### Key Components

- **Storage**: Longhorn (distributed storage), NFS CSI provisioner
- **Networking**: Multus CNI for multi-network pods
- **Virtualization**: KubeVirt for running VMs in Kubernetes
- **Data Import**: CDI (Containerized Data Importer)

---

## 🔧 Scripts

Utility scripts for system administration and automation.

| Script | Description |
|--------|-------------|
| `alpine_docker_install.sh` | Docker installation on Alpine Linux |
| `mount_qcow2.sh` | Mount QCOW2 disk images |
| `mount_encrypted_qcow2.sh` | Mount LUKS-encrypted QCOW2 images |
| `screen_recorder.sh` | Screen recording utility |
| `vmi_health_check/` | KubeVirt VMI health monitoring with auto-restart |

---

## ⚙️ Configs

Configuration files for network and application setup.

| Config | Purpose |
|--------|---------|
| `bridge_interface.conf` | Bridge networking configuration |
| `homepage_config.yaml` | Homepage dashboard ConfigMap |
| `homelab/` | Homepage service configuration files |

### Homepage Dashboard

Complete configuration for the [Homepage](https://gethomepage.dev/) dashboard including:
- `services_.yaml` - Service definitions
- `widgets.yaml` - Kubernetes cluster widgets
- `bookmarks.yaml` - Quick links
- `custom.css` - UI customizations

---

## 🐋 Images

Custom Docker images for specialized workloads.

### gcsfuse

Mount Google Cloud Storage buckets as a filesystem inside containers.

```bash
cd Images/gcsfuse
docker build -t gcsfuse:latest .
```

---

## 📝 Notes

Setup guides and documentation for common tasks.

| Note | Description |
|------|-------------|
| `alpine_linux_docker_install.md` | Docker setup on Alpine Linux |
| `linux_kernel_compilation.md` | Custom kernel compilation guide |
| `new_k3s_node_&_cluster_setup.md` | Complete K3s HA cluster setup guide |

### K3s Cluster Setup Includes

- Bridge interface configuration
- NFS export setup
- MariaDB external datastore
- Longhorn distributed storage
- KubeVirt & CDI installation
- Multus CNI networking
- Volume snapshot support

---

## 🏗️ Infrastructure Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Network (192.168.0.x)                │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Master-01  │  │  Master-02  │  │   Pihole    │      │
│  │   (web)     │  │   (deb)     │  │   (DNS)     │      │
│  │ .113        │  │ .101        │  │             │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
│         │               │                               │
│         └───────┬───────┘                               │
│                 ▼                                       │
│  ┌─────────────────────────────────────────────────┐    │
│  │              K3s HA Cluster                     │    │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────────────┐    │    │
│  │  │Longhorn │ │KubeVirt │ │ Homepage        │    │    │
│  │  │Storage  │ │   VMs   │ │ Dashboard       │    │    │
│  │  └─────────┘ └─────────┘ └─────────────────┘    │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```
