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

# Docker
bash ~/_Book_k8sInfra/ch4/4.2.1/install_docker.sh

# Harbor
cd ~/_Book_k8sInfra/ch4/4.4.2/1.harbor_pki/
bash 1-1.create_certs.sh ; bash 1-2.deploy_certs.sh
cd ../2.harbor
bash 2-1.get_harbor.sh   ; bash 2-2.modify_config.sh
bash 2-3.prepare         ; bash 2-4.install.sh
echo "Waiting 10secs for harbor on" ; sleep 10
docker login 192.168.1.10:8443 -u admin -p admin

# Helm & repo add and then helm_completion.sh to avoid reload shell previously
bash ~/_Book_k8sInfra/ch5/5.2.3/install_helm.sh
/usr/local/bin/helm repo add edu https://k8s-edu.github.io/Bkv2_main/helm-charts
bash ~/_Book_k8sInfra/ch5/5.2.3/helm_completion.sh
