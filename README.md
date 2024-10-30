# Homelab Stacks
- I prefer [Podman](https://podman.io) over Docker.
- All services are only accessible within the local network that is why I didn't enable TLS for them.
- It is recommended to use portainer to manage the containers and services.
- Cockpit is central management dashboard for machines. Management dashboard is running on port 9090.
- All custom DNS is handled by Pihole.

# Host Port Mapping
| Service           | Port                 |
|-------------------|----------------------|
| Cockpit           | 9090                 |

### Container Port Mapping
| Service           | Container Name | Host Port            | Container Port        |
|-------------------|----------------|----------------------|-----------------------|
| Heimdall          | heimdall       | 8080, 80, 443        | 80, 443               |
| Portainer         | portainer      | 8081                 | 9000                  |
| Filebrowser       | filebrowser    | 8082                 | 80                    |
| qBittorrent       | qbittorrent    | 8083, 6881, 6881/udp | 8083, 6881, 6881/udp  |
| Jellyfin          | jellyfin       | 8084                 | 8096                  |
| Pyload-NG         | pyload-ng      | 8085                 | 8000                  |
| Filezilla         | filezilla      | 8086                 | 5800                  |
| Firefox           | firefox        | 8087                 | 5800                  |
| Virt-Manager      | virt-manager   | 8088                 | 80                    |

- `pihole` and `nextcloud` are deployed in separate Alpine Linux VM.

| Service           | Host Port            | Container Port        |
|-------------------|----------------------|-----------------------|
| Pihole            | 53/tcp, 53/udp, 8080 | 53/tcp, 53/udp, 80    |
| Nextcloud         | 80                   | 80                    |
| Portainer-Agent   | 9001                 | 9001                  |
