# Homelab Notes, Stacks, Configs, and Scripts

A comprehensive collection of homelab configurations, deployment stacks, Kubernetes manifests, and utility scripts for self-hosted infrastructure.

---

## 📁 Folder Structure

```
homelab/
├── configs/           # Configuration files for networking and dashboards
├── images/            # Custom Docker images
├── kubernetes/        # Kubernetes manifests and storage configuration
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

Manifests for K3s cluster workloads and storage configuration.

| File | Purpose |
|------|---------|
| [`nfs_storage_class.yaml`](kubernetes/nfs_storage_class.yaml) | NFS CSI StorageClass configuration |

### [Application Manifests](kubernetes/application_manifests/)

Kubernetes deployments, VMs, and data resources.

| Manifest | Purpose |
|----------|---------|
| [`brave_browser.yaml`](kubernetes/application_manifests/brave_browser.yaml) | Brave browser deployment (linuxserver) with Longhorn PVC |
| [`firefox_browser.yaml`](kubernetes/application_manifests/firefox_browser.yaml) | Firefox browser deployment (linuxserver) with Longhorn PVC |
| [`websurfx.yaml`](kubernetes/application_manifests/websurfx.yaml) | WebSurfX search engine deployment |
| [`kafka.yaml`](kubernetes/application_manifests/kafka.yaml) | Apache Kafka (Strimzi) cluster deployment |
| [`garage_s3.yaml`](kubernetes/application_manifests/garage_s3.yaml) | Garage S3-compatible distributed storage |
| [`puppy_linux_vm.yaml`](kubernetes/application_manifests/puppy_linux_vm.yaml) | KubeVirt VM with Puppy Linux ISO |
| [`sample_mini_vm.yaml`](kubernetes/application_manifests/sample_mini_vm.yaml) | Minimal KubeVirt VM template |
| [`debian_12_datavolume.yaml`](kubernetes/application_manifests/debian_12_datavolume.yaml) | CDI DataVolume importing Debian 12 cloud image |

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
| [`rancher_deploy.sh`](scripts/rancher_deploy.sh) | Automated Rancher + cert-manager installation via Helm |
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
| [`homepage_config.yaml`](configs/homepage_config.yaml) | Homepage dashboard Kubernetes ConfigMap |

### Homepage Dashboard

A single Kubernetes ConfigMap ([`homepage_config.yaml`](configs/homepage_config.yaml)) containing all [Homepage](https://gethomepage.dev/) dashboard configuration: services, bookmarks, widgets, custom CSS, Kubernetes integration, and settings. Deployed to the `ctnr` namespace.

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
| [`autossh_setup.md`](notes/autossh_setup.md) | Persistent reverse SSH tunnel with systemd autostart |
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
