#!/usr/bin/env bash

# Avoid 'dpkg-reconfigure: unable to re-open stdin: No file or directory'
export DEBIAN_FRONTEND=noninteractive

# install util packages 
apt-get install sshpass

# add kubernetes repo (pkgs.k8s.io — apt.kubernetes.io was decommissioned 2024-03)
mkdir -p /etc/apt/keyrings
curl \
  -fsSL https://pkgs.k8s.io/core:/stable:/v$2/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo \
  "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
  https://pkgs.k8s.io/core:/stable:/v$2/deb/ /" \
  | tee /etc/apt/sources.list.d/kubernetes.list

# update repo info
apt-get update

# install kubectl
apt-get install -y kubectl=$1

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl

# alias kubectl to k 
echo 'alias k=kubectl' >> ~/.bashrc
echo "alias ka='kubectl apply -f'" >> ~/.bashrc
echo "alias kd='kubectl delete -f'" >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc

# install helm
curl -fsSL https://raw.githubusercontent.com/sysnet4admin/IaC/main/k8s/extra-pkgs/v1.36/get_helm_v4.2.0.sh \
  | DESIRED_VERSION=v4.1.3 bash
