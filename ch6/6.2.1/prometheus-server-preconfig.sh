#!/usr/bin/env bash
nfsdir=/nfs_shared/prometheus/server
set -e
# check helm command
if [ ! -e "/usr/local/bin/helm" ]; then
  echo "helm not found"
  exit 1
fi
# check metallb
echo "Check metallb-system is available"
kubectl get namespace metallb-system
echo "Checked Success!"
# provision nfs and volume
~/_Book_k8sInfra/ch6/6.2.1/nfs-exporter.sh prometheus/server
chown 1000:1000 /nfs_shared/prometheus/server
kubectl apply -f ~/_Book_k8sInfra/ch6/6.2.1/prometheus-volume.yaml