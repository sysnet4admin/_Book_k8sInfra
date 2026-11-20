#!/usr/bin/env bash

# avoid 'dpkg-reconfigure: unable to re-open stdin: No file or directory'
export DEBIAN_FRONTEND=noninteractive

#yum install python36 python36-pip git -y
apt-get update && apt-get install python3-pip sshpass -y 

# git clone https://github.com/kubernetes-sigs/kubespray.git
# kubespray release-2.31 deploys k8s v1.35.x by default (2026-04 release).
# kubespray lags k8s ~1 minor; book main chapters use v1.36 but appendix C
# stays at the latest kubespray-supported version.
git clone -b release-2.31 https://github.com/kubernetes-sigs/kubespray.git
sudo mv kubespray /root

# other ansible, jinja2 netaddr will be installed by requirement.txt (2024.01.12)
#ansible==7.6.0
#cryptography==41.0.4
#jinja2==3.1.2
#jmespath==1.0.1
#MarkupSafe==2.1.3
#netaddr==0.9.0
#pbr==5.11.1
#ruamel.yaml==0.17.35
#ruamel.yaml.clib==0.2.8

# WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. 
# It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
# so stderr(2) to /dev/null 
pip3 install --break-system-packages -r /root/kubespray/requirements.txt 2> /dev/null

# Extend kubeadm controlPlane health check timeout (default 4m is too short for VirtualBox arm64)
TMPL=/root/kubespray/roles/kubernetes/control-plane/templates/kubeadm-config.v1beta4.yaml.j2
sed -i '/^kind: InitConfiguration/a timeouts:\n  controlPlaneComponentHealthCheck: "15m0s"' "$TMPL"

# Set download_run_once and extend kubeadm_init_timeout to match the internal timeout
mkdir -p /root/kubespray/group_vars/all
echo "download_run_once: true" > /root/kubespray/group_vars/all/download-override.yml
echo "kubeadm_init_timeout: 960" >> /root/kubespray/group_vars/all/download-override.yml


cat <<EOF >  /root/kubespray/ansible_hosts.ini
[all]
cp11-k8s ansible_host=192.168.1.11 ip=192.168.1.11 etcd_member_name=etcd11
cp12-k8s ansible_host=192.168.1.12 ip=192.168.1.12 etcd_member_name=etcd12
cp13-k8s ansible_host=192.168.1.13 ip=192.168.1.13 etcd_member_name=etcd13
w101-k8s ansible_host=192.168.1.101 ip=192.168.1.101
w102-k8s ansible_host=192.168.1.102 ip=192.168.1.102
w103-k8s ansible_host=192.168.1.103 ip=192.168.1.103
w104-k8s ansible_host=192.168.1.104 ip=192.168.1.104
w105-k8s ansible_host=192.168.1.105 ip=192.168.1.105
w106-k8s ansible_host=192.168.1.106 ip=192.168.1.106

[kube_control_plane]
cp11-k8s 
cp12-k8s 
cp13-k8s 

[etcd]
cp11-k8s 
cp12-k8s 
cp13-k8s 

[kube_node]
w101-k8s 
w102-k8s 
w103-k8s 
w104-k8s 
w105-k8s 
w106-k8s 

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
EOF
