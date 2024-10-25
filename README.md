# Homelab Stacks
- As in `traefik-dynamic.yaml` I have created individual services for each application, performing port mapping is optional while running docker compose
  as traefik uses internal docker network to route the traffic to the containers. We only need to expose traefik on port 80 and 443.
  Make sure all the containers and traefik are in the same docker network.
- It is recommended to use portainer to manage the containers and services.
