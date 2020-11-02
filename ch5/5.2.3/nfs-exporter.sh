#!/usr/bin/env bash
nfsdir=/nfs_shared/$1

if [ $# -eq 0 ]; then
  echo "usage: nfs-exporter.sh <name>"; exit 0
fi

if [[ ! -d $nfsdir ]]; then
  mkdir $nfsdir
  echo "$nfsdir 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
  systemctl enable --now nfs
fi
