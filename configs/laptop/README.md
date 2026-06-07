# Laptop Setup

These configs are for the laptop running i3 WM natively (not via VNC).

## Default Terminal: Kitty

```sh
sudo apt install -y kitty
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

## Fonts

### JetBrains Mono (regular)

```sh
sudo apt install -y fonts-jetbrains-mono
```

### JetBrains Mono Nerd Font (patched with devicons/powerline)

Download from [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases):

```sh
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip \
  -O /tmp/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/jetbrains-mono-nerd/
fc-cache -fv
```

### Emoji fallback

Noto Color Emoji is used as fallback for emoji glyphs. Install and configure:

```sh
sudo apt install -y fonts-noto-color-emoji
```

Create `~/.config/fontconfig/conf.d/01-emoji-fallback.conf`:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <match target="pattern">
    <edit name="family" mode="append"><string>Noto Color Emoji</string></edit>
  </match>
</fontconfig>
```

Then:

```sh
fc-cache -fv
```

## Touchpad (xinput)

```sh
sudo apt install -y xinput
```

The i3 config runs these commands on startup for the Synaptics touchpad:

- `libinput Natural Scrolling Enabled` — reverse scroll direction
- `libinput Tapping Enabled` — tap to click

Adjust the device name if yours is different.

## Installing configs

```sh
cp i3.config ~/.config/i3/config
cp i3status.config ~/.config/i3status/config
cp kitty.conf ~/.config/kitty/kitty.conf
cp rofi.config ~/.config/rofi/config
cp nvim_init.lua ~/.config/nvim/init.lua
cat shell_config >> ~/.bashrc
```

Restart i3 with `$mod+Shift+R`.

## File Manager

```sh
sudo apt install -y thunar thunar-archive-plugin
```

## GTK Theme (Nordic)

```sh
# download Nordic GTK theme
curl -sL "https://api.github.com/repos/EliverLara/Nordic/tarball/v2.2.0" \
  -o /tmp/nordic.tar.gz
mkdir -p ~/.themes
tar xzf /tmp/nordic.tar.gz -C ~/.themes/
mv ~/.themes/EliverLara-Nordic-* ~/.themes/Nordic
```

Update `~/.config/gtk-3.0/settings.ini`:

```ini
gtk-theme-name=Nordic
```

