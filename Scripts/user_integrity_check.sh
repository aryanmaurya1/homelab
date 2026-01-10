#!/bin/bash

# ======================================
# Linux User-Level Security Scan Script
# ======================================

OUTFILE="$HOME/security_scan_$(date +%Y%m%d_%H%M%S).log"
USER_NAME="$(whoami)"
HOSTNAME="$(hostname)"
TIMESTAMP="$(date)"

SEPARATOR="--------------------------------------------------------------------------------------"

sep() {
    echo "$SEPARATOR" >> "$OUTFILE"
}

# Start report
{
echo "LINUX USER SECURITY SCAN REPORT"
sep
echo "User       : $USER_NAME"
echo "Hostname   : $HOSTNAME"
echo "Timestamp  : $TIMESTAMP"
sep
} > "$OUTFILE"

# 1. User processes
{
echo "1) PROCESSES RUNNING UNDER CURRENT USER"
echo "Command: ps -u $USER_NAME -f"
sep
ps -u "$USER_NAME" -f
sep
} >> "$OUTFILE"

# 2. Process tree
{
echo "2) PROCESS TREE (FOREST VIEW)"
echo "Command: ps -u $USER_NAME -f --forest"
sep
ps -u "$USER_NAME" -f --forest
sep
} >> "$OUTFILE"

# 3. Suspicious execution paths
{
echo "3) PROCESSES RUNNING FROM /tmp, /dev/shm, .cache"
echo "Command: ps -u $USER_NAME -f | egrep '/tmp|/dev/shm|\\.cache'"
sep
ps -u "$USER_NAME" -f | egrep '/tmp|/dev/shm|\.cache' || echo "None found"
sep
} >> "$OUTFILE"

# 4. Network listeners
{
echo "4) NETWORK LISTENERS (USER-LEVEL)"
echo "Command: ss -tulnp | grep $USER_NAME"
sep
ss -tulnp 2>/dev/null | grep "$USER_NAME" || echo "No listening ports"
sep
} >> "$OUTFILE"

# 5. Deleted but running binaries
{
echo "5) DELETED BUT RUNNING EXECUTABLES"
echo "Command: ls -l /proc/*/exe | grep deleted"
sep
ls -l /proc/*/exe 2>/dev/null | grep deleted || echo "None found"
sep
} >> "$OUTFILE"

# 6. High CPU usage
{
echo "6) TOP CPU-CONSUMING PROCESSES"
echo "Command: ps -u $USER_NAME -o pid,cmd,%cpu --sort=-%cpu | head"
sep
ps -u "$USER_NAME" -o pid,cmd,%cpu --sort=-%cpu | head
sep
} >> "$OUTFILE"

# 7. High memory usage
{
echo "7) TOP MEMORY-CONSUMING PROCESSES"
echo "Command: ps -u $USER_NAME -o pid,cmd,%mem --sort=-%mem | head"
sep
ps -u "$USER_NAME" -o pid,cmd,%mem --sort=-%mem | head
sep
} >> "$OUTFILE"

# 8. Logged-in sessions
{
echo "8) ACTIVE LOGIN SESSIONS"
echo "Command: who"
sep
who
sep
} >> "$OUTFILE"

# 9. Shell startup persistence
{
echo "9) SHELL STARTUP FILES (SUSPICIOUS COMMANDS)"
echo "Command: grep -E 'curl|wget|nc|bash|sh' ~/.bashrc ~/.profile ~/.bash_profile"
sep
grep -E 'curl|wget|nc|bash|sh' ~/.bashrc ~/.profile ~/.bash_profile 2>/dev/null || echo "No suspicious entries"
sep
} >> "$OUTFILE"

# 10. Autostart applications
{
echo "10) AUTOSTART APPLICATIONS"
echo "Command: ls ~/.config/autostart/"
sep
ls ~/.config/autostart/ 2>/dev/null || echo "No autostart directory"
sep
} >> "$OUTFILE"

# 11. User cron jobs
{
echo "11) USER CRON JOBS"
echo "Command: crontab -l"
sep
crontab -l 2>/dev/null || echo "No user cron jobs"
sep
} >> "$OUTFILE"

# Finish
{
echo "SECURITY SCAN COMPLETED"
sep
echo "Report saved to: $OUTFILE"
} >> "$OUTFILE"

echo "✔ Security scan complete"
echo "📄 Report saved at: $OUTFILE"
