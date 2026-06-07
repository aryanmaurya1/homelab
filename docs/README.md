# Docs

Setup guides, reference notes, and long-form documentation for the homelab.

## VNC Remote Desktop

All VNC configuration lives in [`configs/vnc/`](../configs/vnc/):

| Config | Target | Purpose |
|--------|--------|---------|
| [`configs/vnc/kitty.conf`](../configs/vnc/kitty.conf) | `~/.config/kitty/kitty.conf` | Terminal: Nord palette, JetBrains Mono 10pt, cursor block |
| [`configs/vnc/i3.config`](../configs/vnc/i3.config) | `~/.config/i3/config` | i3 wm: JetBrains Mono, Nerd Font bar, launches kitty |
| [`configs/vnc/i3status.config`](../configs/vnc/i3status.config) | `~/.config/i3status/config` | Status bar: Nerd Font symbols, 12-hour clock |
| [`configs/vnc/shell_config`](../configs/vnc/shell_config) | Append to `~/.bashrc` | Powerline PS1, colorized ls, vim→nvim alias |
| [`configs/vnc/nvim_init.lua`](../configs/vnc/nvim_init.lua) | `~/.config/nvim/init.lua` | Neovim: VSCode keybindings, Nord theme, plugins |
| [`configs/vnc/xstartup`](../configs/vnc/xstartup) | `~/.vnc/xstartup` | VNC session startup — launches i3 |
| [`configs/vnc/vncserver.service`](../configs/vnc/vncserver.service) | `/etc/systemd/system/vncserver@.service` | systemd unit for TigerVNC |
| [`configs/vnc/wallpaper.png`](../configs/vnc/wallpaper.png) | `~/.wallpaper.png` | Desktop wallpaper |

Full guide with installation steps, keybindings, and management: [`configs/vnc/README.md`](../configs/vnc/README.md)

**Reproduce on a fresh VM:** see the "Installation (from scratch)" section in the guide.

## Guides

| Document | Description |
|----------|-------------|
| [`configs/vnc/README.md`](../configs/vnc/README.md) | i3 + TigerVNC + Kitty remote desktop |
| [`alpine_linux_docker_install.md`](alpine_linux_docker_install.md) | Docker on Alpine Linux |
| [`autossh_setup.md`](autossh_setup.md) | Persistent reverse SSH tunnel with systemd |
| [`linux_kernel_compilation.md`](linux_kernel_compilation.md) | Custom kernel build steps |
| [`new_k3s_node_&_cluster_setup.md`](new_k3s_node_%26_cluster_setup.md) | K3s HA cluster setup (Longhorn, KubeVirt, Multus) |
