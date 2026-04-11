# Kubernetes manifests

Layouts for a K3s-style cluster: application workloads, KubeVirt samples, and storage classes.

| Directory | Contents |
|-----------|----------|
| [`apps/`](apps/) | Deployments, services, and related resources (media, dashboards, messaging, object storage, browsers). |
| [`kubevirt/`](kubevirt/) | KubeVirt VM definitions, data volumes, and the VMI ping-health CronJob. |
| [`storage/`](storage/) | Cluster storage configuration (for example NFS StorageClass). |

Apply order for Homepage: ConfigMap from [`../configs/homepage_config.yaml`](../configs/homepage_config.yaml), then [`apps/homepage.yaml`](apps/homepage.yaml).

Typical cluster stack: Longhorn, NFS CSI, Multus, KubeVirt, CDI.
