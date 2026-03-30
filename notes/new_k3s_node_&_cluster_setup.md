# Kubernetes Cluster Setup

## Creating Bridge Interface

```shell
apt install bridge-utils
cp /etc/network/interfaces ~/interfaces_backup
nano /etc/network/interfaces
```

```txt
auto lo
iface lo inet loopback

auto br0
iface br0 inet dhcp
    bridge_ports enp2s0
    bridge_stp off
    bridge_fd 0
    bridge_maxwait 0
```

## Mounting External HDDs

```shell
mkdir -p /mnt
blkid /dev/sda1 # copy uuid of the hard drive
nano /etc/fstab
```

If `blkid` returns an empty response, use the method below to find the UUID:

```shell
mount /dev/sda1 /mnt
ls -l /dev/disk/by-id/ # copy the id for correct partition
```

```txt
UUID=1846ce39-7681-4b33-89d6-2d8f107a01f0  /mnt  ext4  defaults,nofail  0  2
```

Or use the disk-by-id path:

```txt
/dev/disk/by-id/ata-WDC_WD5000AAKX-221CA1_WD-WCAYUJN23579-part1  /mnt  ext4  defaults,nofail  0  2
```

## Exporting HDD Through NFS

```shell
apt install nfs-kernel-server -y
nano /etc/exports
```

```txt
/mnt  *(rw,sync,no_subtree_check,no_root_squash)
```

```shell
exportfs -ra
exportfs -v # verify it's working
```

## Install prerequisites for Longhorn

```shell
apt-get install open-iscsi -y
modprobe iscsi_tcp
apt-get install nfs-common -y
apt-get install cryptsetup -y
apt-get install dmsetup -y
```

### Enable `dm_crypt` (Longhorn encryption-at-rest)

Longhorn can encrypt volumes with LUKS; the kernel needs the `dm_crypt` device-mapper target loaded on every node.

1. **Check** — if `lsmod | grep dm_crypt` prints nothing, the module is not loaded.
2. **Kernel package** — on minimal installs, install the package that matches your running kernel so the module exists on disk:

   ```shell
   apt install linux-modules-$(uname -r)
   ```

3. **Load now** and verify:

   ```shell
   modprobe dm_crypt
   lsmod | grep dm_crypt
   ```

4. **After reboot** — append `dm_crypt` to `/etc/modules` (one line per module) so it loads at boot:

   ```shell
   grep -qxF dm_crypt /etc/modules || echo dm_crypt | sudo tee -a /etc/modules
   ```

## Install MariaDB

```shell
apt install mariadb-server -y
systemctl enable mariadb --now
mysql_secure_installation
mysql -u root -p
```

```sql
CREATE DATABASE k3s;
CREATE USER 'k3admin'@'%' IDENTIFIED BY 'k3admin';
GRANT ALL PRIVILEGES ON k3s.* TO 'k3admin'@'%';
FLUSH PRIVILEGES;
EXIT;
```

```shell
nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

```txt
bind-address = 0.0.0.0
```

```shell
systemctl restart mariadb
mysql -u k3admin -p -h 192.168.0.137 k3s
```

## Install K3s HA

```shell
export DB_ENDPOINT="mysql://k3admin:k3admin@tcp(192.168.0.137:3306)/k3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --datastore-endpoint='${DB_ENDPOINT}'" sh -
cat /var/lib/rancher/k3s/server/node-token
```

### Service File Verification

```shell
cat /etc/systemd/system/k3s.service
```

```txt
[Unit]
Description=Lightweight Kubernetes
Documentation=https://k3s.io
Wants=network-online.target
After=network-online.target

[Install]
WantedBy=multi-user.target

[Service]
Type=notify
EnvironmentFile=-/etc/default/%N
EnvironmentFile=-/etc/sysconfig/%N
EnvironmentFile=-/etc/systemd/system/k3s.service.env
KillMode=process
Delegate=yes
User=root
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Restart=always
RestartSec=5s
ExecStartPre=/bin/sh -xc '! /usr/bin/systemctl is-enabled --quiet nm-cloud-setup.service 2>/dev/null'
ExecStartPre=-/sbin/modprobe br_netfilter
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/k3s server --datastore-endpoint="mysql://k3admin:k3admin@tcp(192.168.0.137:3306)/k3s"
```

## Install K3s on Second Node

```shell
export DB_ENDPOINT="mysql://k3admin:k3admin@tcp(192.168.0.137:3306)/k3s"
export TOKEN="<NODE_TOKEN>"  # from /var/lib/rancher/k3s/server/node-token on first server
export MASTER1_IP="192.168.0.137"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --server https://${MASTER1_IP}:6443 --token ${TOKEN} --datastore-endpoint='${DB_ENDPOINT}'" sh -
```

## Install Helm4

```shell
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh
```

## Setup Alias (Optional)

```shell
nano ~/.bashrc
```

```txt
alias k='kubectl'
alias kaf='kubectl apply -f -<<EOF'
```

## Install Longhorn

```shell
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --version 1.11.1 \
  --set csi.attacherReplicaCount=1 \
  --set csi.provisionerReplicaCount=1 \
  --set csi.resizerReplicaCount=1 \
  --set csi.snapshotterReplicaCount=1 \
  --set defaultSettings.defaultReplicaCount=1 \
  --set longhornUI.replicas=1 \
  --set persistence.defaultClassReplicaCount=1 \
  --debug
```

## Install VolumeSnapshot Support

### CRDs

```shell
export RELEASE_VERSION=8.5
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-${RELEASE_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-${RELEASE_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-${RELEASE_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
```

### External Snapshotter

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.5.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.5.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```

## Install Multus

HelmChart CR lives in `kube-system` (default cluster namespace; no extra manifest needed). The NAD below targets workloads in `virt`; the file lists `Namespace` first so one `kubectl apply -f` creates `virt` before the definition.

```yaml
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: multus
  namespace: kube-system
spec:
  repo: https://rke2-charts.rancher.io
  chart: rke2-multus
  targetNamespace: kube-system
  valuesContent: |-
    config:
      fullnameOverride: multus
      cni_conf:
        confDir: /var/lib/rancher/k3s/agent/etc/cni/net.d
        binDir: /var/lib/rancher/k3s/data/cni/
        kubeconfig: /var/lib/rancher/k3s/agent/etc/cni/net.d/multus.d/multus.kubeconfig
        multusAutoconfigDir: /var/lib/rancher/k3s/agent/etc/cni/net.d
    manifests:
      dhcpDaemonSet: true
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: virt
---
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-dhcp
  namespace: virt
spec:
  config: '{ "cniVersion": "1.0.0", "type": "bridge", "bridge": "br0", "ipam": { "type":
    "dhcp" } }'
```

## NFS Based PV/PVC

`PersistentVolume` is cluster-scoped (no `metadata.namespace`). The claim is namespaced; `Namespace` is first so `ctnr` exists before the PVC.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: ctnr
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-data-pv
spec:
  capacity:
    storage: 512Gi
  nfs:
    server: 192.168.0.137
    path: /mnt
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  mountOptions:
    - hard
    - nfsvers=4.1
  volumeMode: Filesystem
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-data-pvc
  namespace: ctnr
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 512Gi
  volumeName: nfs-data-pv
  storageClassName: ''
  volumeMode: Filesystem
```

## Install KubeVirt

```shell
export RELEASE=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-cr.yaml
kubectl -n kubevirt wait kv kubevirt --for condition=Available
```

## Install CDI (Containerized Data Importer)

```shell
export TAG=$(curl -s -w '%{redirect_url}' https://github.com/kubevirt/containerized-data-importer/releases/latest)
export VERSION=$(echo ${TAG##*/})
export GODEBUG=netdns=go
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
```

---

## Known Issues

- Jellyfin showing `failed to create fsnotify watcher: too many open files` error

Apply the fix at runtime, then persist it:

```shell
sysctl -w fs.inotify.max_user_instances=8192
```

Add to `/etc/sysctl.conf` to survive reboots:

```txt
fs.inotify.max_user_instances=8192
```

```shell
sysctl -p
cat /proc/sys/fs/inotify/max_user_instances
```
