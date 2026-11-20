#!/usr/bin/env bash
nfsdir=/nfs_shared/$1

# convert term in CentOS and Ubuntu distro linux  
if [[ "$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release)" = *"CentOS"* ]]; then 
  NFS_SVC_NAME="nfs"
elif [[ "$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release)" = *"Ubuntu"* ]]; then
  NFS_SVC_NAME="nfs-server"  
else
  echo "This system is not CentOS as well as Ubuntu"
fi 

# main nfs_exporter
if [ $# -eq 0 ]; then
  echo "usage: nfs_exporter.sh <name>"; exit 0
fi

if [[ ! -d /nfs_shared ]]; then
  mkdir /nfs_shared
fi

if [[ ! -d $nfsdir ]]; then
  mkdir -p $nfsdir
  echo "$nfsdir 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
  if [[ $(systemctl is-enabled "$NFS_SVC_NAME") -eq "disabled" ]]; then
    systemctl enable $NFS_SVC_NAME
  fi
    systemctl restart $NFS_SVC_NAME
fi

# check purpose
echo -e "Check created configurations"
echo -e "==="
echo -e "cat /etc/exports:"
echo -e "$(cat /etc/exports)" | ( DASH=$'  - ' ; sed "s/^/$DASH/" )
echo -e "---"
echo -e "ls /nfs_shared:"
echo -e "$(ls /nfs_shared/)" | ( DASH=$'  - ' ; sed "s/^/$DASH/" )
