#!/usr/bin/env bash
nfsdir=/nfs_shared/prometheus/alertmanager
set -e
# check helm command
if [ ! -e "/usr/local/bin/helm" ]; then
  echo "helm not found"
  exit 1
fi
# check metallb system
echo "Check metallb-system is available"
kubectl get namespace metallb-system
echo "Checked Success!"
# check nfs-volume and provisioning
~/_Book_k8sInfra/ch6/6.5.2/nfs-exporter.sh prometheus/alertmanager
chown 1000:1000 /nfs_shared/prometheus/alertmanager
kubectl apply -f ~/_Book_k8sInfra/ch6/6.5.2/alertmanager-volume.yaml