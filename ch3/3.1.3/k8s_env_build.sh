#!/usr/bin/env bash

# avoid 'dpkg-reconfigure: unable to re-open stdin: No file or directory'
export DEBIAN_FRONTEND=noninteractive

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab (Rmv blank)
sed -i.bak -r 's/(.+swap.+)/#\1/' /etc/fstab

# add kubernetes repo
curl \
  -fsSL https://pkgs.k8s.io/core:/stable:/v$2/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo \
  "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
  https://pkgs.k8s.io/core:/stable:/v$2/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

# add docker-ce repo with containerd
curl -fsSL \
  https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

# enable IPv4 packet forwarding between interfaces
echo 1 > /proc/sys/net/ipv4/ip_forward
# pass bridged packets through iptables (br_netfilter)
modprobe br_netfilter

# local small dns & vagrant cannot parse and delivery shell code.
echo "127.0.0.1 localhost" > /etc/hosts # localhost name will use by calico-node
echo "192.168.1.10 cp-k8s" >> /etc/hosts
for (( i=1; i<=$1; i++  )); do echo "192.168.1.10$i w$i-k8s" >> /etc/hosts; done
