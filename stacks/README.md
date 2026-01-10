# Homelab Docker/Podman Stacks

Self-hosted services running via Docker Compose. [Podman](https://podman.io) is preferred over Docker.

## 📋 Overview

- All services are configured for **local network access only** (no TLS)
- Use [Portainer](portainer/) for container management UI
- Custom DNS handled by [Pihole](pihole/)
- Host management via Cockpit (port `9090`)

---

## 🚀 Quick Start

```bash
cd <service-folder>
docker-compose up -d

# Or with Podman
podman-compose up -d
```

---

## 📊 Service Categories

### 🖥️ Dashboards & Management

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Heimdall | [heimdall/](heimdall/) | 8080 | 80, 443 | Application dashboard |
| Portainer | [portainer/](portainer/) | 8081 | 9000 | Container management UI |

### 🎬 Media Servers

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Jellyfin | [jellyfin/](jellyfin/) | 8084 | 8096 | Media streaming server |
| Immich | [immich/](immich/) | 8097 | 2283 | Photo & video management |
| Dim | [dim/](dim/) | 8089 | 8000 | Media manager |

### 📚 Digital Libraries

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Kavita | [kavita/](kavita/) | 8093 | 8080 | eBooks, comics, manga |
| Komga | [komga/](komga/) | 8092 | 25600 | Comics & manga server |
| Stump | [stump/](stump/) | 8091 | 10801 | Comics server |

### 📥 Download Tools

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| qBittorrent | [qbittorrent/](qbittorrent/) | 8083, 6881 | 8083, 6881 | Torrent client |
| Pyload-NG | [pyload/](pyload/) | 8085 | 8000 | Download manager |
| Prowlarr | [prowlarr/](prowlarr/) | - | - | Indexer manager |
| Sonarr | [sonarr/](sonarr/) | - | - | TV series manager |

### 📁 File Management

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Filebrowser | [filebrowser/](filebrowser/) | 8082 | 80 | Web file manager |
| Filestash | [filestash/](filestash/) | 8090 | 8334 | File manager with integrations |
| Filezilla | [filezilla/](filezilla/) | 8086 | 5800 | FTP client (web UI) |
| DockerFTP | [dockerftp/](dockerftp/) | 8095, 8096 | 20, 21 | FTP server |
| NFS | [nfs/](nfs/) | 2049 | 2049 | Network file sharing |

### 🌐 Web Browsers

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Firefox | [firefox/](firefox/) | 8087 | 5800 | Firefox in container |
| Librewolf | [librewolf/](librewolf/) | - | - | Privacy-focused browser |

### ☁️ Cloud & Productivity

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Nextcloud | [nextcloud/](nextcloud/) | 80 | 80 | Self-hosted cloud storage |
| Code-Server | [codeserver/](codeserver/) | 8094 | 8080 | VS Code in browser |

### 🔒 Networking & DNS

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Pihole | [pihole/](pihole/) | 53, 8080 | 53, 80 | DNS & ad blocker |
| Twingate | [twingate/](twingate/) | - | - | Zero trust network access |

### 🌍 Web Servers

| Service | Folder | Description |
|---------|--------|-------------|
| Caddy | [webservers/caddy/](webservers/caddy/) | Modern web server with auto HTTPS |
| Nginx Proxy Manager | [webservers/nginx-proxy-manager/](webservers/nginx-proxy-manager/) | Reverse proxy with GUI |
| Traefik | [webservers/traefik/](webservers/traefik/) | Cloud-native reverse proxy |

### 🛠️ Other Services

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| VMM | [vmm/](vmm/) | 8088 | 80 | Virtual machine manager |
| Webcord | [webcord/](webcord/) | - | - | Discord client |

---

## 🖧 Host Services

| Service | Port | Description |
|---------|------|-------------|
| Cockpit | 9090 | System management dashboard |

---

## 📝 Notes

- **Pihole** and **Nextcloud** are deployed in a separate Alpine Linux VM for isolation
- **Portainer-Agent** (port `9001`) enables remote management from main Portainer instance

---

## 📁 Folder Structure

```
Stacks/
├── codeserver/
├── dim/
├── dockerftp/
├── filebrowser/
├── filestash/
├── filezilla/
├── firefox/
├── heimdall/
├── immich/
├── jellyfin/
├── kavita/
├── komga/
├── librewolf/
├── nextcloud/
├── nfs/
├── pihole/
├── portainer/
├── prowlarr/
├── pyload/
├── qbittorrent/
├── sonarr/
├── stump/
├── twingate/
├── vmm/
├── webcord/
└── webservers/
    ├── caddy/
    ├── nginx-proxy-manager/
    └── traefik/
```
