# Homelab Stacks
- As in `traefik-dynamic.yaml` I have created individual services for each application, performing port mapping is optional while running docker compose.
- Traefik uses internal docker network to route the traffic to the containers. We only need to expose traefik on port 80 and 443.
- Make sure all the containers and traefik are in the same docker network.
- It is recommended to use portainer to manage the containers and services.

# Host Port Mapping
| Port                | Service           |
|---------------------|-------------------|
| 8080                | Traefik Dashboard |
| 8081                | Portainer         |
| 8082                | Filebrowser       |
| 8083, 6881, 6881/udp| qBittorrent       |
| 8084                | Jellyfin          |
| 8085                | Pyload            |
