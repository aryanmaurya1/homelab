# VNC Remote Desktop (i3 + TigerVNC + Kitty)

Headless VM GUI accessed via VNC with the i3 tiling window manager.

## Overview

| Component | Choice |
|-----------|--------|
| VNC Server | TigerVNC (`tigervnc-standalone-server`) |
| Window Manager | i3 (tiling) |
| Terminal | Kitty |
| Wallpaper Setter | feh |
| Auth | VNC password (`admin`) |

## Files

### Configs (`configs/vnc/`)

| File | Purpose |
|------|---------|
| [`configs/vnc/xstartup`](../configs/vnc/xstartup) | VNC session startup — launches i3 |
| [`configs/vnc/i3.config`](../configs/vnc/i3.config) | i3 window manager config |
| [`configs/vnc/i3status.config`](../configs/vnc/i3status.config) | i3status bar config |
| [`configs/vnc/kitty.conf`](../configs/vnc/kitty.conf) | Kitty terminal config |
| [`configs/vnc/vncserver.service`](../configs/vnc/vncserver.service) | systemd unit for VNC |
| [`configs/vnc/wallpaper.png`](../configs/vnc/wallpaper.png) | Desktop wallpaper |

### Target paths on the VM

```
~/.vnc/xstartup
~/.config/i3/config
~/.config/i3status/config
~/.config/kitty/kitty.conf
/etc/systemd/system/vncserver@.service
~/.wallpaper.png
```

## Key bindings (i3)

| Binding | Action |
|---------|--------|
| `Alt+Enter` | Open terminal (kitty) |
| `Alt+d` | dmenu launcher |
| `Alt+1`–`0` | Switch workspace |
| `Alt+Shift+q` | Kill focused window |
| `Alt+Shift+e` | Exit i3 (ends VNC session) |
| `Alt+Shift+r` | Restart i3 |
| `Alt+Shift+c` | Reload i3 config |
| `Alt+f` | Toggle fullscreen |
| `Alt+v` | Split vertical |
| `Alt+h` | Split horizontal |
| `Alt+j/k/l` | Focus left/down/up/right |
| `Alt+Shift+j/k/l` | Move window left/down/up/right |
| `Alt+arrows` | Focus direction |
| `Alt+Shift+arrows` | Move window direction |

## How to connect

```
Host: <vm-ip>:5901
Password: admin
Protocol: VNC (TigerVNC recommended)
```

## Cursor fix

Kitty's shell integration overrides the cursor shape to **beam** (vertical bar) at shell prompts. The fix is `shell_integration no-cursor` in `kitty.conf`, which prevents the shell integration from changing cursor shape.

## Management

```bash
# Start/stop/restart
systemctl start vncserver@1
systemctl stop vncserver@1
systemctl restart vncserver@1
systemctl status vncserver@1

# Change password
vncpasswd

# View logs
tail -f ~/.vnc/dev.pve.red:1.log
```

The service auto-starts on boot (`systemctl enable vncserver@1`).

## Resolution

Set via `-geometry` in `vncserver.service`. Current: `1280x720` (720p). Edit the file and restart the service to change.

## Bar (i3status)

Shows: ethernet IP, disk available, load, memory, time. Battery and IPv6 modules are removed (not relevant on a VM).

## Installation (from scratch)

```bash
apt-get update
apt-get install -y tigervnc-standalone-server i3 kitty feh xauth x11-utils

mkdir -p ~/.vnc
echo "admin" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Copy configs from repo to target paths (see table above)
# Enable and start the service
systemctl daemon-reload
systemctl enable vncserver@1
systemctl start vncserver@1
```
