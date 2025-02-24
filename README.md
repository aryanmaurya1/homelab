# Homelab Notes, Stacks, Configs, and Scripts

## Notes
- [Linux Kernel Compilation](Notes/linux_kernel_compilation.md)

## Stacks
- Stacks contains docker-compose files for each service.

#### Web Servers
Web servers also contains there configuration files along with `docker-compose` files.
- [Caddy](https://hub.docker.com/_/caddy)
- [Nignx Proxy Manager](https://nginxproxymanager.com/guide/#quick-setup)
- [Traefik](https://hub.docker.com/_/traefik)

#### Services
- [Heimdall](https://hub.docker.com/r/linuxserver/heimdall)
- [Portainer](https://docs.portainer.io/start/install-ce/server/docker/linux)
- [Filebrowser](https://filebrowser.org/installation)
- [qBittorrent](https://hub.docker.com/r/linuxserver/qbittorrent)
- [Jellyfin](https://jellyfin.org/docs/general/installation/container/)
- [Pyload-NG](https://hub.docker.com/r/linuxserver/pyload-ng)
- [Filezilla](https://github.com/jlesage/docker-filezilla)
- [Firefox](https://github.com/jlesage/docker-firefox)
- [Virt-Manager](https://github.com/m-bers/docker-virt-manager)
- [Dim](https://github.com/Dusk-Labs/dim?tab=readme-ov-file)
- [Filestash](https://www.filestash.app/docs/install-and-upgrade/#installation)
- [Pihole](https://hub.docker.com/r/pihole/pihole)
- [Nextcloud](https://hub.docker.com/_/nextcloud)
- [Stump](https://www.stumpapp.dev/installation/docker)
- [Komga](https://komga.org/docs/installation/docker/)
- [Kavita](https://hub.docker.com/r/linuxserver/kavita)
- [Code-Server](https://hub.docker.com/r/linuxserver/code-server)
- [DockerFTP](https://github.com/garethflowers/docker-ftp-server)
- [Immich](https://immich.app/docs/install/docker-compose)
- [NFS-Server](https://hub.docker.com/r/itsthenetwork/nfs-server-alpine/)

#### Machines
| Hostname  | Purpose                          | Operating System  | Type       |
|-----------|----------------------------------|-------------------|------------|
| m1.io     | Virtualization host for all VMs | Debian           | Bare Metal |
| m2.io     | Dedicated DNS server            | Alpine Linux     | VM         |
| m3.io     | Single-node K3s cluster         | Debian           | VM         |
| m4.io     | Development.                    | Debian           | VM         |
| m5.io     | Raspberry Pi for critical workloads | Ubuntu Server   | Bare Metal |
| m6.io     | Immich Server (uses gcsfuse)        | Debian           | VM         |

### Services Running on Raspberry Pi

| Service        | Container Name      | Host Port                                | Container Port                      | Active |
|---------------|---------------------|------------------------------------------|--------------------------------------|--------|
| portainer     | portainer           | 0.0.0.0:8000, :::8000, 0.0.0.0:9443, :::9443 | 8000/tcp, 9443/tcp, 9000/tcp        | ✅     |
| pihole        | pihole              | 0.0.0.0:53, :::53, 0.0.0.0:80, :::80     | 53/tcp, 80/tcp, 53/udp, 67/udp      | ✅     |
| portainer_agent | portainer_agent   | 0.0.0.0:9001, :::9001                    | 9001/tcp                            | ✅     |


## Configs
- [Bridge Interface](Configs/bridge_interface.conf)
