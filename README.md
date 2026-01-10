# Homelab Notes, Stacks, Configs, and Scripts

A comprehensive collection of homelab configurations, deployment stacks, Kubernetes manifests, and utility scripts for self-hosted infrastructure.

---

## 📁 Folder Structure

```
homelab/
├── configs/           # Configuration files for various services
├── images/            # Custom Docker images
├── kubernetes/        # Kubernetes manifests and deployment scripts
├── notes/             # Documentation and setup guides
├── scripts/           # Utility and automation scripts
└── stacks/            # Docker/Podman compose files for services
```

---

## 🐳 [Stacks](stacks/)

Docker Compose files for self-hosted services. Podman is preferred over Docker. All services are configured for local network access only (no TLS).

| Service | Port | Description |
|---------|------|-------------|
| [**Heimdall**](stacks/heimdall/) | 8080 | Application dashboard |
| [**Portainer**](stacks/portainer/) | 8081 | Container management UI |
| [**Filebrowser**](stacks/filebrowser/) | 8082 | Web-based file manager |
| [**qBittorrent**](stacks/qbittorrent/) | 8083 | Torrent client |
| [**Jellyfin**](stacks/jellyfin/) | 8084 | Media server |
| [**Pyload-NG**](stacks/pyload/) | 8085 | Download manager |
| [**Filezilla**](stacks/filezilla/) | 8086 | FTP client (web UI) |
| [**Firefox**](stacks/firefox/) | 8087 | Browser in container |
| [**Kavita**](stacks/kavita/) | 8093 | Digital library |
| [**Immich**](stacks/immich/) | 8097 | Photo management |
| [**NFS**](stacks/nfs/) | 2049 | Network file sharing |

### Additional Services

- **Webservers**: [Caddy](stacks/webservers/caddy/), [Nginx Proxy Manager](stacks/webservers/nginx-proxy-manager/), [Traefik](stacks/webservers/traefik/)
- **Media**: [Dim](stacks/dim/), [Stump](stacks/stump/), [Komga](stacks/komga/) (comic/manga readers)
- **Networking**: [Pihole](stacks/pihole/) (DNS), [Twingate](stacks/twingate/) (VPN)
- **Cloud**: [Nextcloud](stacks/nextcloud/), [Code-Server](stacks/codeserver/)
- **Other**: [Filestash](stacks/filestash/), [Librewolf](stacks/librewolf/), [Prowlarr](stacks/prowlarr/), [Sonarr](stacks/sonarr/), [Webcord](stacks/webcord/), [VMM](stacks/vmm/), [DockerFTP](stacks/dockerftp/)

---

## ☸️ [Kubernetes](kubernetes/)

Manifests and scripts for K3s cluster management.

| File | Purpose |
|------|---------|
| [`rancher_deploy.sh`](kubernetes/rancher_deploy.sh) | Automated Rancher + cert-manager installation |
| [`nfs_storage_class.yaml`](kubernetes/nfs_storage_class.yaml) | NFS CSI StorageClass configuration |
| [`websurfx.yaml`](kubernetes/websurfx.yaml) | WebSurfX search engine deployment |
| [`manifests/kafka.yaml`](kubernetes/manifests/kafka.yaml) | Apache Kafka deployment |

### Key Components

- **Storage**: Longhorn (distributed storage), NFS CSI provisioner
- **Networking**: Multus CNI for multi-network pods
- **Virtualization**: KubeVirt for running VMs in Kubernetes
- **Data Import**: CDI (Containerized Data Importer)

---

## 🔧 [Scripts](scripts/)

Utility scripts for system administration and automation.

| Script | Description |
|--------|-------------|
| [`alpine_docker_install.sh`](scripts/alpine_docker_install.sh) | Docker installation on Alpine Linux |
| [`mount_qcow2.sh`](scripts/mount_qcow2.sh) | Mount QCOW2 disk images |
| [`mount_encrypted_qcow2.sh`](scripts/mount_encrypted_qcow2.sh) | Mount LUKS-encrypted QCOW2 images |
| [`screen_recorder.sh`](scripts/screen_recorder.sh) | Screen recording utility |
| [`system_integrity_check.sh`](scripts/system_integrity_check.sh) | Root-level Linux security audit (processes, listeners, modules, binaries) |
| [`user_integrity_check.sh`](scripts/user_integrity_check.sh) | User-level security scan (processes, cron, autostart, shell configs) |
| [`vmi_health_check/`](scripts/vmi_health_check/) | KubeVirt VMI health monitoring with auto-restart |

---

## ⚙️ [Configs](configs/)

Configuration files for network and application setup.

| Config | Purpose |
|--------|---------|
| [`bridge_interface.conf`](configs/bridge_interface.conf) | Bridge networking configuration |
| [`homepage_config.yaml`](configs/homepage_config.yaml) | Homepage dashboard ConfigMap |
| [`homelab/`](configs/homelab/) | Homepage service configuration files |

### Homepage Dashboard

Complete configuration for the [Homepage](https://gethomepage.dev/) dashboard including:
- [`services_.yaml`](configs/homelab/services_.yaml) - Service definitions
- [`widgets.yaml`](configs/homelab/widgets.yaml) - Kubernetes cluster widgets
- [`bookmarks.yaml`](configs/homelab/bookmarks.yaml) - Quick links
- [`custom.css`](configs/homelab/custom.css) - UI customizations
- [`settings.yaml`](configs/homelab/settings.yaml) - Dashboard settings
- [`docker.yaml`](configs/homelab/docker.yaml) - Docker integration
- [`kubernetes.yaml`](configs/homelab/kubernetes.yaml) - Kubernetes integration

---

## 🐋 [Images](images/)

Custom Docker images for specialized workloads.

### [gcsfuse](images/gcsfuse/)

Mount Google Cloud Storage buckets as a filesystem inside containers.

| File | Purpose |
|------|---------|
| [`dockerfile`](images/gcsfuse/dockerfile) | Docker image definition |
| [`main.sh`](images/gcsfuse/main.sh) | Entrypoint script |
| [`run.sh`](images/gcsfuse/run.sh) | Container run helper |

```bash
cd images/gcsfuse
docker build -t gcsfuse:latest .
```

---

## 📝 [Notes](notes/)

Setup guides and documentation for common tasks.

| Note | Description |
|------|-------------|
| [`alpine_linux_docker_install.md`](notes/alpine_linux_docker_install.md) | Docker setup on Alpine Linux |
| [`linux_kernel_compilation.md`](notes/linux_kernel_compilation.md) | Custom kernel compilation guide |
| [`new_k3s_node_&_cluster_setup.md`](notes/new_k3s_node_%26_cluster_setup.md) | Complete K3s HA cluster setup guide |

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
