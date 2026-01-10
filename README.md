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

## 🐳 [Stacks](Stacks/)

Docker Compose files for self-hosted services. Podman is preferred over Docker. All services are configured for local network access only (no TLS).

| Service | Port | Description |
|---------|------|-------------|
| [**Heimdall**](Stacks/heimdall/) | 8080 | Application dashboard |
| [**Portainer**](Stacks/portainer/) | 8081 | Container management UI |
| [**Filebrowser**](Stacks/filebrowser/) | 8082 | Web-based file manager |
| [**qBittorrent**](Stacks/qbittorrent/) | 8083 | Torrent client |
| [**Jellyfin**](Stacks/jellyfin/) | 8084 | Media server |
| [**Pyload-NG**](Stacks/pyload/) | 8085 | Download manager |
| [**Filezilla**](Stacks/filezilla/) | 8086 | FTP client (web UI) |
| [**Firefox**](Stacks/firefox/) | 8087 | Browser in container |
| [**Kavita**](Stacks/kavita/) | 8093 | Digital library |
| [**Immich**](Stacks/immich/) | 8097 | Photo management |
| [**NFS**](Stacks/nfs/) | 2049 | Network file sharing |

### Additional Services

- **Webservers**: [Caddy](Stacks/webservers/caddy/), [Nginx Proxy Manager](Stacks/webservers/nginx-proxy-manager/), [Traefik](Stacks/webservers/traefik/)
- **Media**: [Dim](Stacks/dim/), [Stump](Stacks/stump/), [Komga](Stacks/komga/) (comic/manga readers)
- **Networking**: [Pihole](Stacks/pihole/) (DNS), [Twingate](Stacks/twingate/) (VPN)
- **Cloud**: [Nextcloud](Stacks/nextcloud/), [Code-Server](Stacks/codeserver/)
- **Other**: [Filestash](Stacks/filestash/), [Librewolf](Stacks/librewolf/), [Prowlarr](Stacks/prowlarr/), [Sonarr](Stacks/sonarr/), [Webcord](Stacks/webcord/), [VMM](Stacks/vmm/), [DockerFTP](Stacks/dockerftp/)

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

## 🔧 [Scripts](Scripts/)

Utility scripts for system administration and automation.

| Script | Description |
|--------|-------------|
| [`alpine_docker_install.sh`](Scripts/alpine_docker_install.sh) | Docker installation on Alpine Linux |
| [`mount_qcow2.sh`](Scripts/mount_qcow2.sh) | Mount QCOW2 disk images |
| [`mount_encrypted_qcow2.sh`](Scripts/mount_encrypted_qcow2.sh) | Mount LUKS-encrypted QCOW2 images |
| [`screen_recorder.sh`](Scripts/screen_recorder.sh) | Screen recording utility |
| [`system_integrity_check.sh`](Scripts/system_integrity_check.sh) | Root-level Linux security audit (processes, listeners, modules, binaries) |
| [`user_integrity_check.sh`](Scripts/user_integrity_check.sh) | User-level security scan (processes, cron, autostart, shell configs) |
| [`vmi_health_check/`](Scripts/vmi_health_check/) | KubeVirt VMI health monitoring with auto-restart |

---

## ⚙️ [Configs](Configs/)

Configuration files for network and application setup.

| Config | Purpose |
|--------|---------|
| [`bridge_interface.conf`](Configs/bridge_interface.conf) | Bridge networking configuration |
| [`homepage_config.yaml`](Configs/homepage_config.yaml) | Homepage dashboard ConfigMap |
| [`homelab/`](Configs/homelab/) | Homepage service configuration files |

### Homepage Dashboard

Complete configuration for the [Homepage](https://gethomepage.dev/) dashboard including:
- [`services_.yaml`](Configs/homelab/services_.yaml) - Service definitions
- [`widgets.yaml`](Configs/homelab/widgets.yaml) - Kubernetes cluster widgets
- [`bookmarks.yaml`](Configs/homelab/bookmarks.yaml) - Quick links
- [`custom.css`](Configs/homelab/custom.css) - UI customizations
- [`settings.yaml`](Configs/homelab/settings.yaml) - Dashboard settings
- [`docker.yaml`](Configs/homelab/docker.yaml) - Docker integration
- [`kubernetes.yaml`](Configs/homelab/kubernetes.yaml) - Kubernetes integration

---

## 🐋 [Images](Images/)

Custom Docker images for specialized workloads.

### [gcsfuse](Images/gcsfuse/)

Mount Google Cloud Storage buckets as a filesystem inside containers.

| File | Purpose |
|------|---------|
| [`dockerfile`](Images/gcsfuse/dockerfile) | Docker image definition |
| [`main.sh`](Images/gcsfuse/main.sh) | Entrypoint script |
| [`run.sh`](Images/gcsfuse/run.sh) | Container run helper |

```bash
cd Images/gcsfuse
docker build -t gcsfuse:latest .
```

---

## 📝 [Notes](Notes/)

Setup guides and documentation for common tasks.

| Note | Description |
|------|-------------|
| [`alpine_linux_docker_install.md`](Notes/alpine_linux_docker_install.md) | Docker setup on Alpine Linux |
| [`linux_kernel_compilation.md`](Notes/linux_kernel_compilation.md) | Custom kernel compilation guide |
| [`new_k3s_node_&_cluster_setup.md`](Notes/new_k3s_node_%26_cluster_setup.md) | Complete K3s HA cluster setup guide |

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
