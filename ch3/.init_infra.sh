#!/usr/bin/env bash

# LoadBalancer 
kubectl apply -f ~/_Book_k8sInfra/ch3/3.3.2/metallb-native-v0.15.3.yaml
echo "Waiting 60secs for MetalLB CRD" ; sleep 60
kubectl apply -f ~/_Book_k8sInfra/ch3/3.3.2/metallb-l2-iprange.yaml

# StorageClass  
kubectl apply -f ~/_Book_k8sInfra/ch3/3.4.3/csi-driver-nfs-v4.12.1.yaml
echo "Waiting 30secs for CSI driver NFS" ; sleep 30
kubectl apply -f ~/_Book_k8sInfra/ch3/3.4.3/storageclass.yaml
bash ~/_Book_k8sInfra/ch3/3.4.3/nfs_exporter.sh "dynamic-vol"

