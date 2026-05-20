#!/usr/bin/env bash
# VolumeSnapshot support investigation (read-only).
# Cluster: k3s HA per docs/new_k3s_node_&_cluster_setup.md
# Date: 2026-05-21
# Do not apply anything from this file unless you intend to change the cluster.

set -euo pipefail

echo "=== Cluster connectivity ==="
kubectl version
kubectl cluster-info | head -5

echo "=== Snapshot-related API resources ==="
kubectl api-resources | grep -i snapshot

echo "=== Snapshot.storage API versions ==="
kubectl api-versions | grep snapshot.storage

echo "=== Volume Snapshot CRDs ==="
kubectl get crd | grep -E 'volumesnapshot|snapshot.storage'

echo "=== VolumeSnapshotClass CRD detail ==="
kubectl get crd volumesnapshotclasses.snapshot.storage.k8s.io -o yaml

echo "=== Volume snapshot objects (expect VolumeSnapshotClass: none) ==="
kubectl get volumesnapshotclass
kubectl get volumesnapshot -A
kubectl get volumesnapshotcontent

echo "=== Snapshot controller (kube-system) ==="
kubectl get deployment,pods -n kube-system -l app.kubernetes.io/name=snapshot-controller
kubectl get deployment -n kube-system snapshot-controller -o yaml

echo "=== Snapshot controller RBAC ==="
kubectl get serviceaccount,clusterrole,clusterrolebinding -A | grep -i snapshot

echo "=== Longhorn CSI snapshot sidecar ==="
kubectl get deployment,pods -n longhorn-system | grep -i snapshot
kubectl get deployment -n longhorn-system csi-snapshotter -o yaml
kubectl logs -n longhorn-system deploy/csi-snapshotter --tail=50

echo "=== CSI driver and storage classes ==="
kubectl get csidriver
kubectl get storageclass

echo "=== RBAC: can snapshot-controller list VolumeSnapshotClasses? ==="
kubectl auth can-i list volumesnapshotclasses.snapshot.storage.k8s.io \
  --as=system:serviceaccount:kube-system:snapshot-controller

echo "=== Longhorn version ==="
kubectl get settings.longhorn.io -n longhorn-system current-longhorn-version -o yaml

# --- Reference only: NOT applied during investigation ---
# Per Longhorn 1.11.1 docs, create default VolumeSnapshotClass after CRDs + controller:
# kubectl apply -f - <<'EOF'
# apiVersion: snapshot.storage.k8s.io/v1
# kind: VolumeSnapshotClass
# metadata:
#   name: longhorn
# driver: driver.longhorn.io
# deletionPolicy: Delete
# EOF
