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
| Service           | Container Name | Host Port            | Container Port        | Active |
|-------------------|----------------|----------------------|-----------------------|--------|
| Heimdall          | heimdall       | 8080, 80, 443        | 80, 443               | [x]    |
| Portainer         | portainer      | 8081                 | 9000                  | [x]    |
| Filebrowser       | filebrowser    | 8082                 | 80                    | [x]    |
| qBittorrent       | qbittorrent    | 8083, 6881, 6881/udp | 8083, 6881, 6881/udp  | [x]    |
| Jellyfin          | jellyfin       | 8084                 | 8096                  | [x]    |
| Pyload-NG         | pyload-ng      | 8085                 | 8000                  | [x]    |
| Filezilla         | filezilla      | 8086                 | 5800                  | [x]    |
| Firefox           | firefox        | 8087                 | 5800                  | [x]    |
| Virt-Manager      | virt-manager   | 8088                 | 80                    | [ ]    |
| Dim               | dim            | 8089                 | 8000                  | [ ]    |
| Filestash         | filestash      | 8090                 | 8334                  | [ ]    |
| Stump             | stump          | 8091                 | 10801                 | [ ]    |
| Komga             | komga          | 8092                 | 25600                 | [ ]    |
| Kavita            | kavita         | 8093                 | 8080                  | [x]    |
| Code-Server       | code-server    | 8094                 | 8080                  | [ ]    |
| DockerFTP         | dockerftp      | 8095, 8096           | 20, 21                | [x]    |
| Immich            | immich-server  | 8097                 | 2283                  | [x]    |
| NFS               | nfs-server     | 2049                 | 2049                  | [x]    |

- `pihole` and `nextcloud` are deployed in separate Alpine Linux VM.

| Service           | Host Port            | Container Port        | Active |
|-------------------|----------------------|-----------------------|--------|
| Pihole            | 53/tcp, 53/udp, 8080 | 53/tcp, 53/udp, 80    | [x]    |
| Nextcloud         | 80                   | 80                    | [ ]    |
| Portainer-Agent   | 9001                 | 9001                  | [x]    |
