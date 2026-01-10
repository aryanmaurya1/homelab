# Kubernetes Cluster Setup

## Creating Bridge Interface

```shell
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

```txt
UUID=1846ce39-7681-4b33-89d6-2d8f107a01f0  /mnt  ext4  defaults,nofail  0  2
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
mysql -u k3admin -p -h 192.168.0.113 k3s
```

## Install K3s HA

```shell
export DB_ENDPOINT="mysql://k3admin:k3admin@tcp(192.168.0.113:3306)/k3s?charset=utf8mb4,utf8&parseTime=True"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --datastore-endpoint='${DB_ENDPOINT}'" sh -
cat /var/lib/rancher/k3s/server/node-token
```

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
ExecStart=/usr/local/bin/k3s server --datastore-endpoint="mysql://k3admin:k3admin@tcp(192.168.0.113:3306)/k3s?charset=utf8mb4,utf8&parseTime=True"

```

## Install K3s on Second Node

```shell
export DB_ENDPOINT="mysql://k3admin:k3admin@tcp(192.168.0.113:3306)/k3s?charset=utf8mb4,utf8&parseTime=True"
export TOKEN="K10665c6660f876d12bc058dadb5f0d07005b3245c1b8b987741a9cdde360a82e15::server:9fc73a9d176fb129ba0e18527f72df94"
export MASTER1_IP="192.168.0.113"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --server https://${MASTER1_IP}:6443 --token ${TOKEN} --datastore-endpoint='${DB_ENDPOINT}'" sh -
```

## Install Longhorn

```shell
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --version 1.9.0 \
  --set csi.attacherReplicaCount=1 \
  --set csi.provisionerReplicaCount=1 \
  --set csi.resizerReplicaCount=1 \
  --set csi.snapshotterReplicaCount=1 \
  --set defaultSettings.defaultReplicaCount=1 \
  --set longhornUI.replicas=1 \
  --set persistence.defaultClassReplicaCount=1
```

## Install VS/VSC Support

### CRDs

```shell
RELEASE_VERSION=8.3
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-${RELEASE_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-${RELEASE_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-${RELEASE_VERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
```

### External Snapshotter

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.3.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.3.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```

## Installing Multus

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
    manifests:
      dhcpDaemonSet: true
```

```yaml
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

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
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

```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: nfs-data-pv
spec:
  capacity:
    storage: 512Gi
  nfs:
    server: 192.168.0.113
    path: /mnt
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  mountOptions:
    - hard
    - nfsvers=4.1
  volumeMode: Filesystem
```

## Kubevirt Installation

```shell
export RELEASE=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-cr.yaml
kubectl -n kubevirt wait kv kubevirt --for condition=Available
```

## CDI Installation

```shell
export TAG=$(curl -s -w %{redirect_url} https://github.com/kubevirt/containerized-data-importer/releases/latest)
export VERSION=$(echo ${TAG##*/})
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
```

---

## Known Issues

- Jellyfin showing `failed to create fsnotify watcher: too many open files` error

```shell
sysctl -w fs.inotify.max_user_instances=8192
nano /etc/sysctl.conf

# Add below line at the end of file
# fs.inotify.max_user_instances=8192

sysctl -p
cat /proc/sys/fs/inotify/max_user_instances # Verify current limit
```
