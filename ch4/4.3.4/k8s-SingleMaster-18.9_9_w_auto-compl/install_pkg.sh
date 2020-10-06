#!/usr/bin/env bash

# install packages 
yum install epel-release -y
yum install vim-enhanced -y
yum install git -y

# install docker 
yum install docker-ce-18.09.9-3.el7 docker-ce-cli-18.09.9-3.el7 \
    containerd.io-1.2.6-3.3.el7 -y
systemctl enable --now docker

# install kubernetes and kubectl will install only master node 
if [ $2 = 'install_kubectl' ]; then
  yum install kubectl-$1 -y
fi
yum install kubelet-$1 kubeadm-$1 -y 
systemctl enable --now kubelet

