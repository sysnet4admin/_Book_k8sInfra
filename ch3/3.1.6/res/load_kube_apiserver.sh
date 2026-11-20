#!/usr/bin/env bash

# load k8s API-Server 
mv /tmp/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml 
echo "Loading kube-apiserver"
echo "Wait for 1 minute!!!"

