#!/usr/bin/env bash
nfsdir=/nfs_shared/prometheus/alertmanager
set -e
# check helm command
if [ ! -e "/usr/local/bin/helm" ]; then
  echo "helm is not found"
  exit 1
fi
# check metallb system
echo "Check metallb-system is available"
kubectl get namespace metallb-system
echo "Checked Success!"
# check nfs-volume and provisioning
if [[ ! -d $nfsdir ]]; then
  mkdir -p $nfsdir
  echo "$nfsdir 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
  chown 1000:1000 -R $nfsdir
  if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then
    systemctl enable nfs
  fi
  systemctl restart nfs
  kubectl apply -f ~/_Book_k8sInfra/ch6/6.5.2/alertmanager-volume.yaml
else
  echo "nfs directory and pv, pvc already setup!!"
fi