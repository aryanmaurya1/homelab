# Autossh Documentation

## Persistent Reverse SSH Tunnel With Autostart

---

## 1. Overview

**autossh** is a tool that keeps SSH tunnels alive automatically.  
If the connection drops (network hiccup, ISP reset, VPS reboot), autossh will reconnect without manual intervention.

**Typical Use Case**

- Home or office machine behind NAT / CGNAT
- No inbound ports available
- Public VPS available
- Need reliable remote SSH access from anywhere

---

## 2. Architecture

```text
Client (anywhere)
   ↓
VPS (public IP)
   ↓  reverse SSH tunnel
Home Gateway (LAN)
   ↓
Other LAN machines (192.168.0.0/24)
```

The home gateway initiates the connection outward, making it firewall-friendly.

---

## 3. Prerequisites

**Home Gateway (inside LAN):**

- Linux machine that is always on
- SSH server running (`sshd`)
- Network access to other LAN machines

**VPS:**

- Public IP address
- SSH access
- Port available for forwarding (e.g. 2222)

**Client:**

- SSH client only (no special setup)

---

## 4. Installing autossh

**Debian / Ubuntu:**
```bash
sudo apt update
sudo apt install autossh -y
```

**RHEL / CentOS / Rocky:**
```bash
sudo dnf install autossh -y
```

**Verify installation:**
```bash
autossh -V
```

---

## 5. SSH Key Setup (Required)

**Never use password authentication for tunnels.**

**Generate key on home gateway:**
```bash
ssh-keygen -t ed25519 -f ~/.ssh/autossh_ed25519
```

**Copy key to VPS:**
```bash
ssh-copy-id -i ~/.ssh/autossh_ed25519.pub user@vps
```

**Test key:**
```bash
ssh -i ~/.ssh/autossh_ed25519 user@vps
```

---

## 6. VPS SSH Configuration

**Edit the SSH config:**
```bash
sudo nano /etc/ssh/sshd_config
```

**Ensure the following are set:**
```
AllowTcpForwarding yes
GatewayPorts yes
PasswordAuthentication no
```

**Restart SSH:**
```bash
sudo systemctl restart ssh
```

---

## 7. Manual autossh Command (Test First)

**Run on the home gateway:**
```bash
autossh -M 0 -N \
  -i ~/.ssh/autossh_ed25519 \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -R 2222:localhost:22 \
  user@VPS_PUBLIC_IP
```

**What this does:**
- Opens port 2222 on the VPS
- Forwards it to home-gateway:22
- Reconnects automatically if dropped
- Does not open a shell on the VPS

---

## 8. Connecting From Anywhere

**From any client on the internet:**
```bash
ssh -p 2222 gatewayuser@VPS_PUBLIC_IP
```

You are now logged into the home gateway.

**From there:**
```bash
ssh user@192.168.0.3
```

---

## 9. Running Commands on LAN Machines (One-Liner)

**From your client machine:**
```bash
ssh -t -p 2222 gatewayuser@VPS_PUBLIC_IP "ssh user@192.168.0.3 ls"
```

---

## 10. Making autossh Start on Boot (systemd)

### 10.1 Create systemd Service File

```bash
sudo nano /etc/systemd/system/autossh-tunnel.service
```

**Paste:**
```ini
[Unit]
Description=AutoSSH Reverse Tunnel to VPS
After=network-online.target
Wants=network-online.target

[Service]
User=gatewayuser
Environment="AUTOSSH_GATETIME=0"
ExecStart=/usr/bin/autossh -M 0 -N \
  -i /home/gatewayuser/.ssh/autossh_ed25519 \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -R 2222:localhost:22 \
  user@VPS_PUBLIC_IP
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### 10.2 Enable and Start Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable autossh-tunnel
sudo systemctl start autossh-tunnel
```

**Check status:**
```bash
systemctl status autossh-tunnel
```

**View logs:**
```bash
journalctl -u autossh-tunnel -f
```

---

## 11. Firewall Considerations

**On VPS:**  
Allow the forwarded port:
```bash
sudo ufw allow 2222/tcp
```

**On Home Gateway:**  
No inbound ports required.

---

## 12. Security Best Practices

- ✅ Use SSH keys only
- ✅ Disable root login on VPS
- ✅ Use a non-standard port (not 22)
- ✅ Limit users on VPS
- ✅ Monitor logs

**Optional hardening:**
```
AllowUsers tunneluser
```

---

## 13. Limitations of autossh

| Limitation           | Explanation              |
|----------------------|-------------------------|
| One entry point      | Only exposes one machine|
| No full LAN routing  | Requires hopping        |
| SSH-only             | Not a VPN               |
| Scaling is manual    | Each service needs a port|

---

## 14. When to Upgrade

If you need:

- Direct access to many LAN machines
- File sharing
- Databases, web apps, RDP
- Mobile device access

➡️ **Switch to WireGuard or Tailscale**

---

## 15. Summary

- **autossh** provides reliable reverse SSH tunnels
- Perfect for NAT-restricted environments
- Simple, secure, and lightweight
- Ideal for single gateway access
- Autostart via systemd makes it production-ready