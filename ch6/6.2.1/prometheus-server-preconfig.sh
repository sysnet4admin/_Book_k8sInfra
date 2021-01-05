#!/usr/bin/env bash

# check helm command
echo "[Step 1/4] Task [Check helm status]"
if [ ! -e "/usr/local/bin/helm" ]; then
  echo "[Step 1/4] helm not found"
  exit 1
fi
echo "[Step 1/4] ok"

# check metallb
echo "[Step 2/4] Task [Check MetalLB status]"
namespace=$(kubectl get namespace metallb-system -o jsonpath={.metadata.name} 2> /dev/null)
if [ "$namespace" == "" ]; then
  echo "[Step 2/4] metallb not found"
  exit 1
fi
echo "[Step 2/4] ok"

# create nfs directory & change owner
nfsdir=/nfs_shared/prometheus/server
echo "[Step 3/4] Task [Create NFS directory for prometheus-server]"
if [ ! -e "$nfsdir"  ]; then
  ~/_Book_k8sInfra/ch6/6.2.1/nfs-exporter.sh prometheus/server
  chown 1000:1000 $nfsdir
  echo "$nfsdir created"
  echo "[Step 3/4] Successfully completed"
else
  echo "[Step 3/4] failed: $nfsdir already exists"
  exit 1
fi

# create pv,pvc
echo "[Step 4/4] Task [Create PV,PVC for prometheus-server]"
pvc=$(kubectl get pvc prometheus-server -o jsonpath={.metadata.name} 2> /dev/null)
if [ "$pvc" == "" ]; then
  kubectl apply -f ~/_Book_k8sInfra/ch6/6.2.1/prometheus-server-volume.yaml
  echo "[Step 4/4] Successfully completed"
else
  echo "[Step 4/4] failed: prometheus-server pv,pvc already exist"
fi