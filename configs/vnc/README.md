# VNC Remote Desktop (i3 + TigerVNC + Kitty)

Headless VM GUI accessed via VNC with the i3 tiling window manager.

## Overview

| Component | Choice |
|-----------|--------|
| VNC Server | TigerVNC (`tigervnc-standalone-server`) |
| Window Manager | i3 (tiling) |
| Terminal | Kitty (JetBrains Mono Nerd Font) |
| Text Editor | Neovim (VSCode keybindings) |
| Wallpaper Setter | feh |
| App Launcher | rofi |
| Shell | Bash (Nord powerline prompt) |
| Auth | VNC password (`admin`) |

## Files — `configs/vnc/`

| File | Target Path | Purpose |
|------|-------------|---------|
| [`kitty.conf`](../configs/vnc/kitty.conf) | `~/.config/kitty/kitty.conf` | Terminal: Nord palette, JetBrains Mono 10pt, cursor block |
| [`i3.config`](../configs/vnc/i3.config) | `~/.config/i3/config` | i3 wm: JetBrains Mono, launches kitty on start |
| [`i3status.config`](../configs/vnc/i3status.config) | `~/.config/i3status/config` | Status bar: Nerd Font symbols, 12-hour clock |
| [`shell_config`](../configs/vnc/shell_config) | Append to `~/.bashrc` | Powerline PS1, colorized ls, vim→nvim alias |
| [`nvim_init.lua`](../configs/vnc/nvim_init.lua) | `~/.config/nvim/init.lua` | Neovim: VSCode keybindings, Nord theme, plugins |
| [`xstartup`](../configs/vnc/xstartup) | `~/.vnc/xstartup` | VNC session startup — launches i3 |
| [`vncserver.service`](../configs/vnc/vncserver.service) | `/etc/systemd/system/vncserver@.service` | systemd unit managing TigerVNC |
| [`rofi.config`](../configs/vnc/rofi.config) | `~/.config/rofi/config.rasi` | App launcher: Nord theme, icons, 2-column grid |
| [`wallpaper.png`](../configs/vnc/wallpaper.png) | `~/.wallpaper.png` | Desktop wallpaper |

## Installation (from scratch)

```bash
# Packages
apt-get update
apt-get install -y tigervnc-standalone-server i3 kitty feh neovim \
  xauth x11-utils curl git rofi

# Nerd Font (icons for bar and nvim-tree)
mkdir -p /usr/local/share/fonts
curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
  -o /tmp/jetbrains.tar.xz
tar xJf /tmp/jetbrains.tar.xz -C /usr/local/share/fonts/
fc-cache -f

# VNC password
mkdir -p ~/.vnc
echo "admin" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Copy configs from repo to target paths (see table above)
cp configs/vnc/kitty.conf ~/.config/kitty/kitty.conf
cp configs/vnc/i3.config ~/.config/i3/config
cp configs/vnc/i3status.config ~/.config/i3status/config
cp configs/vnc/xstartup ~/.vnc/xstartup
cp configs/vnc/vncserver.service /etc/systemd/system/vncserver@.service
cp configs/vnc/wallpaper.png ~/.wallpaper.png
cp configs/vnc/nvim_init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/rofi
cp configs/vnc/rofi.config ~/.config/rofi/config.rasi
cat configs/vnc/shell_config >> ~/.bashrc

# Install neovim plugins
nvim --headless "+PlugInstall" +qa

# Enable and start VNC
systemctl daemon-reload
systemctl enable vncserver@1
systemctl start vncserver@1
```

## Key bindings

### i3

| Binding | Action |
|---------|--------|
| `Alt+Enter` | Open terminal (kitty) |
| `Alt+d` | rofi launcher (app grid) |
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

### Neovim (VSCode-style)

| Binding | Action |
|---------|--------|
| `Ctrl+S` | Save |
| `Ctrl+P` | Find files (fuzzy) |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+B` | Toggle file explorer |
| `Ctrl+F` | Search in files |
| `Ctrl+W` | Close buffer/tab |
| `Ctrl+Tab` / `Shift+Tab` | Next/previous buffer |
| `Ctrl+N` | New file |
| `Ctrl+A` | Select all |
| `Ctrl+Z` / `Ctrl+Y` | Undo / Redo |
| `Ctrl+/` | Toggle comment |
| `Alt+↑/↓` | Move line up/down |
| `Alt+Shift+↓` | Duplicate line |
| `Ctrl+←/→/↑/↓` | Navigate panes |

## i3 status bar

Shows Nerd Font icons with colorized values:

```
 192.168.0.x (speed) |  15 GiB |  0.5 |  2 GiB used |  2026-06-02 06:12 PM
```

Modules: ethernet IP, disk available, CPU load, memory, time (12-hour).

## Shell prompt

Nord powerline prompt with segments:

```
   user@host  ~/project  main  $
```

- Colored by Nord palette (blue user, gray directory, blue git branch)
- Git branch auto-appears in repos
- Red error segment on failed commands

## Color scheme

All components share the **Nord** palette (`#2e3440` dark background, `#d8dee9` foreground):

- **Kitty** — 16 ANSI colors, selection, cursor, tab bar, URL, mark colors
- **i3** — Nord background via xstartup (`xsetroot -solid "#2e3440"`)
- **Neovim** — nord-vim colorscheme, lualine with nord theme
- **i3status** — color output enabled

## Cursor fix

Kitty's shell integration overrides the cursor shape to beam at shell prompts.
The fix is `shell_integration no-cursor` in `kitty.conf`.

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
tail -f ~/.vnc/*:1.log
```

## Resolution

Set via `-geometry` in `vncserver.service`. Current: `1280x720` (720p).
Edit the file and restart the service to change.

## How to connect

```
Host: <vm-ip>:5901
Password: admin
Protocol: VNC (TigerVNC recommended)
```
