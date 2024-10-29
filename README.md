# Homelab Stacks
- I prefer [Podman](https://podman.io) over Docker.
- As in `traefik-dynamic.yaml` I have created individual services for each application, performing port mapping is optional while running docker compose.
- All services are only accessible within the local network that is why I didn't enable TLS for them.
- Traefik uses internal docker network to route the traffic to the containers. We only need to expose traefik on port 80 and 443.
- Make sure all the containers and traefik are in the same docker network.
- It is recommended to use portainer to manage the containers and services.
- Cockpit is central management dashboard for machines. Management dashboard is running on port 9090.
- All custom DNS is handled by Pihole.

# Host Port Mapping
| Service           | Host Port            | Container Port        |
|-------------------|----------------------|-----------------------|
| Traefik           | 80, 443              | 80, 443               |
| Portainer         | 8081                 | 9000                  |
| Filebrowser       | 8082                 | 80                    |
| qBittorrent       | 8083, 6881, 6881/udp | 8083, 6881, 6881/udp  |
| Jellyfin          | 8084                 | 8096                  |
| Pyload            | 8085                 | 8000                  |
| Filezilla         | 8086                 | 5800                  |

- `pihole` and `nextcloud` are deployed in separate Alpine Linux VM.

| Service           | Host Port            | Container Port        |
|-------------------|----------------------|-----------------------|
| Pihole            | 53/tcp, 53/udp, 8080 | 53/tcp, 53/udp, 80    |
| Nextcloud         | 80                   | 80                    |
| Portainer-Agent   | 9001                 | 9001                  |
