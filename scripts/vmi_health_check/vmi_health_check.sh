#!/bin/bash

exec 9>/var/run/vmi_health_check.lock || exit 1
flock -n 9 || exit 0

export PATH=/usr/local/bin:/usr/bin:/bin
export KUBECONFIG=/root/.kube/config   # adjust if needed

/usr/bin/python3 /usr/local/bin/vmi_health_check.py \
  >> /var/log/vmi_health_check.log 2>&1