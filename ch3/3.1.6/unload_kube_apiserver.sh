#!/usr/bin/env bash

# unload k8s API-Server 
cp /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/kube-apiserver-backup.yaml 
mv /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/kube-apiserver.yaml 
echo "Unloaded kube-apiserver"

