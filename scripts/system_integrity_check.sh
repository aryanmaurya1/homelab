#!/bin/bash

# ======================================
# ROOT-LEVEL LINUX SECURITY AUDIT SCRIPT
# ======================================

# Must run as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root (sudo)"
    exit 1
fi

USER_NAME="${SUDO_USER:-root}"
HOSTNAME="$(hostname)"
TIMESTAMP="$(date)"
OUTFILE="$(pwd)/security_scan_root_$(date +%Y%m%d_%H%M%S).log"

SEPARATOR="--------------------------------------------------------------------------------------"

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m"

sep() {
    echo "$SEPARATOR" | tee -a "$OUTFILE"
}

log() {
    echo -e "$1" | tee -a "$OUTFILE"
}

flag() {
    echo -e "${RED}[SUSPICIOUS]${NC} $1" | tee -a "$OUTFILE"
}

ok() {
    echo -e "${GREEN}[OK]${NC} $1" | tee -a "$OUTFILE"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$OUTFILE"
}

# Header
{
echo "LINUX ROOT-LEVEL SECURITY AUDIT REPORT"
sep
echo "Invoking User : $USER_NAME"
echo "Run as root   : YES"
echo "Hostname      : $HOSTNAME"
echo "Timestamp     : $TIMESTAMP"
sep
} > "$OUTFILE"

log "${BLUE}Starting root-level security audit...${NC}"

# 1. All running processes
sep
log "${BLUE}1) ALL RUNNING PROCESSES${NC}"
log "Command: ps aux"
ps aux | tee -a "$OUTFILE"

# 2. Processes from suspicious locations
sep
log "${BLUE}2) PROCESSES RUNNING FROM DANGEROUS PATHS${NC}"
log "Command: ps aux | egrep '/tmp|/dev/shm|\\.cache'"
BAD_PROC=$(ps aux | egrep '/tmp|/dev/shm|\.cache' | grep -v firefox)

if [[ -n "$BAD_PROC" ]]; then
    flag "Processes running from suspicious locations:"
    echo "$BAD_PROC" | tee -a "$OUTFILE"
else
    ok "No suspicious execution paths found"
fi

# 3. Network listeners
sep
log "${BLUE}3) NETWORK LISTENERS (SYSTEM-WIDE)${NC}"
log "Command: ss -tulnp"
LISTENERS=$(ss -tulnp)

echo "$LISTENERS" | tee -a "$OUTFILE"

if echo "$LISTENERS" | grep -E 'LISTEN.*(nc|netcat|python|perl|bash)'; then
    flag "Suspicious listening services detected"
else
    ok "No suspicious listeners detected"
fi

# 4. Deleted but running executables
sep
log "${BLUE}4) DELETED BUT RUNNING EXECUTABLES${NC}"
log "Command: ls -l /proc/*/exe | grep deleted"
DELETED=$(ls -l /proc/*/exe 2>/dev/null | grep deleted)

if [[ -n "$DELETED" ]]; then
    flag "Deleted but running executables detected"
    echo "$DELETED" | tee -a "$OUTFILE"
else
    ok "No deleted executables running"
fi

# 5. High CPU usage
sep
log "${BLUE}5) HIGH CPU USAGE CHECK${NC}"
log "Command: ps aux --sort=-%cpu | head"
CPU_HOGS=$(ps aux --sort=-%cpu | head)

echo "$CPU_HOGS" | tee -a "$OUTFILE"

if echo "$CPU_HOGS" | grep -Ei '(xmrig|minerd|crypto)'; then
    flag "Possible crypto-mining activity detected"
else
    ok "No known crypto-mining patterns"
fi

# 6. Cron jobs (all users)
sep
log "${BLUE}6) CRON JOBS (ALL USERS)${NC}"
log "Command: crontab -u <user> -l"
for u in $(cut -f1 -d: /etc/passwd); do
    crontab -u "$u" -l 2>/dev/null | sed "s/^/[CRON][$u] /"
done | tee -a "$OUTFILE"

if grep -E '/tmp|curl|wget|nc' "$OUTFILE"; then
    warn "Cron jobs contain potentially dangerous commands"
else
    ok "No suspicious cron jobs detected"
fi

# 7. Startup & persistence locations
sep
log "${BLUE}7) STARTUP & PERSISTENCE LOCATIONS${NC}"
log "Command: find /etc/systemd/system /etc/init.d ~/.config/autostart"
find /etc/systemd/system /etc/init.d ~/.config/autostart 2>/dev/null | tee -a "$OUTFILE"

# 8. Loaded kernel modules
sep
log "${BLUE}8) LOADED KERNEL MODULES${NC}"
log "Command: lsmod"
lsmod | tee -a "$OUTFILE"

# 9. Package integrity check (Debian/Ubuntu)
sep
log "${BLUE}9) SYSTEM BINARY INTEGRITY CHECK${NC}"
log "Command: debsums -s"
if command -v debsums &>/dev/null; then
    DEBSUMS=$(debsums -s)
    if [[ -n "$DEBSUMS" ]]; then
        flag "Modified system binaries detected"
        echo "$DEBSUMS" | tee -a "$OUTFILE"
    else
        ok "System binaries integrity intact"
    fi
else
    warn "debsums not installed"
fi

# 10. Authentication & error logs
sep
log "${BLUE}10) AUTHENTICATION & ERROR LOGS${NC}"
log "Command: journalctl -p err -n 50"
journalctl -p err -n 50 | tee -a "$OUTFILE"

# Completion
sep
log "${GREEN}SECURITY AUDIT COMPLETED${NC}"
log "Report saved to: $OUTFILE"

echo -e "${GREEN}✔ Root-level security audit complete${NC}"
echo -e "${BLUE}📄 Report:${NC} $OUTFILE"
