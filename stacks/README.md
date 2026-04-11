# Docker / Podman stacks

Compose files for self-hosted services. [Podman](https://podman.io) is preferred over Docker. The rest of this repository (Kubernetes, `docs/`, scripts) is described in the [root README](../README.md).

## Overview

- All services are configured for **local network access only** (no TLS)
- Use [Portainer](portainer/) for container management UI
- Custom DNS handled by [Pihole](pihole/)
- Host management via Cockpit (port `9090`)
- **Host port overlaps:** Several stacks use the same host port (e.g. **8081** for Portainer, qBittorrent, and Firefox; **8080** for Heimdall, Filebrowser, and Pihole’s UI). Adjust `ports:` or run one stack at a time on a shared host.

---

## Quick start

```bash
cd <service-folder>
docker-compose up -d

# Or with Podman
podman-compose up -d
```

---

## Service categories

### Dashboards and management

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Heimdall | [heimdall/](heimdall/) | 80, 443, 8080 | 80, 443 | Application dashboard |
| Portainer | [portainer/](portainer/) | 8081 | 9000 | Container management UI |

### Media servers

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Jellyfin | [jellyfin/](jellyfin/) | 8096 | 8096 | Media streaming server |
| Immich | [immich/](immich/) | 80, 443 | 2283 | Photo & video management |
| Dim | [dim/](dim/) | 8089 | 8000 | Media manager |

### Digital libraries

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Kavita | [kavita/](kavita/) | 8093 | 5000 | eBooks, comics, manga |
| Komga | [komga/](komga/) | 8092 | 25600 | Comics & manga server |
| Stump | [stump/](stump/) | 8091 | 10801 | Comics server |

### Download tools

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| qBittorrent | [qbittorrent/](qbittorrent/) | 8081, 6881 | 8081, 6881 | Torrent client |
| Pyload-NG | [pyload/](pyload/) | 8085 | 8000 | Download manager |
| Prowlarr | [prowlarr/](prowlarr/) | 8087 | 9696 | Indexer manager |
| Sonarr | [sonarr/](sonarr/) | 8086 | 8989 | TV series manager |

### File management

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Filebrowser | [filebrowser/](filebrowser/) | 8080 | 80 | Web file manager |
| Filestash | [filestash/](filestash/) | 8090 | 8334 | File manager with integrations |
| Filezilla | [filezilla/](filezilla/) | 5800 | 5800 | FTP client (web UI) |
| DockerFTP | [dockerftp/](dockerftp/) | 8095, 8096 | 20, 21 | FTP server |
| NFS | [nfs/](nfs/) | 2049 | 2049 | Network file sharing |

### Web browsers

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Firefox | [firefox/](firefox/) | 8081 | 5800 | Firefox in container |
| Librewolf | [librewolf/](librewolf/) | 8082 | 3000 | Privacy-focused browser |

### Cloud and productivity

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Nextcloud | [nextcloud/](nextcloud/) | 80 | 80 | Self-hosted cloud storage |
| Code-Server | [codeserver/](codeserver/) | 8094 | 8080 | VS Code in browser |

### Networking and DNS

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| Pihole | [pihole/](pihole/) | 53, 8080 | 53, 80 | DNS & ad blocker |
| Twingate | [twingate/](twingate/) | - | - | Zero trust network access |

### Web servers / reverse proxies

| Service | Folder | Description |
|---------|--------|-------------|
| Caddy | [webservers/caddy/](webservers/caddy/) | Modern web server with auto HTTPS |
| Nginx Proxy Manager | [webservers/nginx-proxy-manager/](webservers/nginx-proxy-manager/) | Reverse proxy with GUI |
| Traefik | [webservers/traefik/](webservers/traefik/) | Cloud-native reverse proxy |

### Other services

| Service | Folder | Host Port | Container Port | Description |
|---------|--------|-----------|----------------|-------------|
| VMM | [vmm/](vmm/) | 8084 | 80 | Virtual machine manager |
| Webcord | [webcord/](webcord/) | 8083 | 3000 | Discord client |

---

## Host services

| Service | Port | Description |
|---------|------|-------------|
| Cockpit | 9090 | System management dashboard |

---

## Notes

- **Pihole** and **Nextcloud** are deployed in a separate Alpine Linux VM for isolation
- **Portainer-Agent** (port `9001`) enables remote management from main Portainer instance

---

## Folder layout

```
stacks/
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
