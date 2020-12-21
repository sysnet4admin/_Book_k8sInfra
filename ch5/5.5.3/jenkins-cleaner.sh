#!/usr/bin/env bash

echo "cleanup lab environment: start"
kubectl delete deployment gitops-nginx
helm uninstall jenkins
kubectl delete -f ~/_Book_k8sInfra/ch5/5.3.1/jenkins-volume.yaml
exportfs -u 192.168.1.0/24:/nfs_shared/jenkins
rm -rf /nfs_shared/jenkins
systemctl restart nfs
echo "cleanup lab environment: Done"