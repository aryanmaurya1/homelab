# Homelab Stacks
- I prefer [Podman](https://podman.io) over Docker.
- As in `traefik-dynamic.yaml` I have created individual services for each application, performing port mapping is optional while running docker compose.
- Traefik uses internal docker network to route the traffic to the containers. We only need to expose traefik on port 80 and 443.
- Make sure all the containers and traefik are in the same docker network.
- It is recommended to use portainer to manage the containers and services.

# Host Port Mapping
| Service           | Host Port            | Container Port        |
|-------------------|----------------------|-----------------------|
| Traefik Dashboard | 8080                 | 8080                  |
| Portainer         | 8081                 | 9000                  |
| Filebrowser       | 8082                 | 80                    |
| qBittorrent       | 8083, 6881, 6881/udp | 8083, 6881, 6881/udp  |
| Jellyfin          | 8084                 | 8096                  |
| Pyload            | 8085                 | 8000                  |
| Filezilla         | 8086                 | 5800                  |
