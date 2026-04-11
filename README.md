# Homelab

Configurations, Docker Compose stacks, Kubernetes manifests, shared configs, and scripts for self-hosted infrastructure.

---

## Repository layout

```
homelab/
├── configs/           # Shared configs (network, Homepage ConfigMap source, etc.)
├── docs/              # Setup guides and long-form notes
├── images/            # Custom container images
├── kubernetes/        # K8s manifests: apps/, kubevirt/, storage/ (see kubernetes/README.md)
├── scripts/           # Utilities and automation
└── stacks/            # Docker/Podman Compose services
```

---

## [Stacks](stacks/)

Docker Compose files for self-hosted services. Podman is preferred over Docker. All services are configured for local network access only (no TLS). More detail: [stacks/README.md](stacks/README.md).

**Host ports:** Values below match each stack’s `docker-compose` file. Several stacks reuse the same host port (for example **8081** for Portainer, qBittorrent Web UI, and Firefox; **8080** for Heimdall and Filebrowser). Only one service can bind a given host port—change mappings or stop conflicting stacks before starting another.

| Service | Port | Description |
|---------|------|-------------|
| [**Heimdall**](stacks/heimdall/) | 80, 443, 8080→80 | Application dashboard |
| [**Portainer**](stacks/portainer/) | 8081 | Container management UI |
| [**Filebrowser**](stacks/filebrowser/) | 8080 | Web-based file manager |
| [**qBittorrent**](stacks/qbittorrent/) | 8081 (+ 6881 tcp/udp) | Torrent client |
| [**Jellyfin**](stacks/jellyfin/) | 8096 | Media server |
| [**Pyload-NG**](stacks/pyload/) | 8085 | Download manager |
| [**Filezilla**](stacks/filezilla/) | 5800 | FTP client (web UI) |
| [**Firefox**](stacks/firefox/) | 8081 | Browser in container |
| [**Kavita**](stacks/kavita/) | 8093 | Digital library |
| [**Immich**](stacks/immich/) | 80, 443→2283 | Photo management |
| [**NFS**](stacks/nfs/) | 2049 | Network file sharing |

### Additional Services

- **Webservers**: [Caddy](stacks/webservers/caddy/), [Nginx Proxy Manager](stacks/webservers/nginx-proxy-manager/), [Traefik](stacks/webservers/traefik/)
- **Media**: [Dim](stacks/dim/), [Stump](stacks/stump/), [Komga](stacks/komga/) (comic/manga readers)
- **Networking**: [Pihole](stacks/pihole/) (DNS), [Twingate](stacks/twingate/) (VPN)
- **Cloud**: [Nextcloud](stacks/nextcloud/), [Code-Server](stacks/codeserver/)
- **Other**: [Filestash](stacks/filestash/), [Librewolf](stacks/librewolf/), [Prowlarr](stacks/prowlarr/), [Sonarr](stacks/sonarr/), [Webcord](stacks/webcord/), [VMM](stacks/vmm/), [DockerFTP](stacks/dockerftp/)

---

## [Kubernetes](kubernetes/)

Index: [kubernetes/README.md](kubernetes/README.md).

### [Storage](kubernetes/storage/)

| File | Purpose |
|------|---------|
| [`nfs_storage_class.yaml`](kubernetes/storage/nfs_storage_class.yaml) | NFS CSI StorageClass |

### [Apps](kubernetes/apps/)

Deployments, services, and related resources.

| Manifest | Purpose |
|----------|---------|
| [`firefox.yaml`](kubernetes/apps/firefox.yaml) | LinuxServer Firefox; Longhorn `/config`; NodePort **3000** / **3001** |
| [`jellyfin.yaml`](kubernetes/apps/jellyfin.yaml) | LinuxServer Jellyfin; Longhorn `/config`, NFS PVC `/data`; NodePort **8096** |
| [`qbittorrent.yaml`](kubernetes/apps/qbittorrent.yaml) | LinuxServer qBittorrent; Longhorn `/config`, NFS PVC `/downloads`; **8080** Web UI + **6881** TCP/UDP (NodePort) |
| [`filebrowser.yaml`](kubernetes/apps/filebrowser.yaml) | [`filebrowser/filebrowser:s6`](https://hub.docker.com/r/filebrowser/filebrowser); Longhorn `/config` + `/database`, NFS PVC `/srv`; NodePort **80** |
| [`homepage.yaml`](kubernetes/apps/homepage.yaml) | [Homepage](https://gethomepage.dev/) in `kube-system`; ClusterIP **3000**; apply [`configs/homepage_config.yaml`](configs/homepage_config.yaml) first |
| [`flame.yaml`](kubernetes/apps/flame.yaml) | [Flame](https://github.com/pawelmalak/flame) dashboard in `ctnr`; seed job mirrors links from `configs/homepage_config.yaml` |
| [`kafka.yaml`](kubernetes/apps/kafka.yaml) | Strimzi Kafka (`kafka` namespace); plain **9092** (NodePort), TLS **9093** (internal) |
| [`garage_s3.yaml`](kubernetes/apps/garage_s3.yaml) | [Garage](https://garagehq.deuxfleurs.fr/) S3-compatible storage (`garage` namespace) |
| [`brave.yaml`](kubernetes/apps/brave.yaml) | LinuxServer Brave (`brave` namespace); NodePort **3000** / **3001** |
| [`websurfx.yaml`](kubernetes/apps/websurfx.yaml) | WebSurfx metasearch (`websurfx` namespace); NodePort **8080** |

### [KubeVirt](kubernetes/kubevirt/)

VM definitions, data volumes, and cluster automation (for example periodic VMI ping health). Reference material alongside the heavier workloads in `apps/`.

### Cluster components (typical)

- **Storage**: Longhorn, NFS CSI
- **Networking**: Multus
- **Virtualization**: KubeVirt
- **Data import**: CDI

---

## [Scripts](scripts/)

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

## [Configs](configs/)

Configuration files for network and application setup.

| Config | Purpose |
|--------|---------|
| [`bridge_interface.conf`](configs/bridge_interface.conf) | Bridge networking configuration |
| [`homepage_config.yaml`](configs/homepage_config.yaml) | Homepage dashboard Kubernetes ConfigMap |

### Homepage Dashboard

A single Kubernetes ConfigMap ([`homepage_config.yaml`](configs/homepage_config.yaml)) containing all [Homepage](https://gethomepage.dev/) dashboard configuration: services, bookmarks, widgets, custom CSS, Kubernetes integration, and settings. The checked-in manifest uses the **`kube-system`** namespace (same as [`homepage.yaml`](kubernetes/apps/homepage.yaml)).

---

## [Images](images/)

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

## [Documentation](docs/)

| Document | Description |
|----------|-------------|
| [`alpine_linux_docker_install.md`](docs/alpine_linux_docker_install.md) | Docker on Alpine Linux |
| [`autossh_setup.md`](docs/autossh_setup.md) | Persistent reverse SSH tunnel with systemd |
| [`linux_kernel_compilation.md`](docs/linux_kernel_compilation.md) | Custom kernel build |
| [`new_k3s_node_&_cluster_setup.md`](docs/new_k3s_node_%26_cluster_setup.md) | K3s HA cluster setup |

### K3s Cluster Setup Includes

- Bridge interface configuration
- NFS export setup
- MariaDB external datastore
- Longhorn distributed storage
- KubeVirt & CDI installation
- Multus CNI networking
- Volume snapshot support

---

## Infrastructure overview

```
┌─────────────────────────────────────────────────────────┐
│                    Network (192.168.0.x)                │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Master-01  │  │  Master-02  │  │   Pihole    │      │
│  │   (uno)     │  │   (duo)     │  │   (DNS)     │      │
│  │ .137        │  │ .184        │  │             │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
│         │               │                               │
│         └───────┬───────┘                               │
│                 ▼                                       │
│  ┌─────────────────────────────────────────────────┐    │
│  │                 K3s HA Cluster                  │    │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────────────┐    │    │
│  │  │Longhorn │ │KubeVirt │ │ Homepage        │    │    │
│  │  │Storage  │ │   VMs   │ │ Dashboard       │    │    │
│  │  └─────────┘ └─────────┘ └─────────────────┘    │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```
