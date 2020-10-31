#!/usr/bin/env bash
mkdir -p /nfs_shared/dashboard
echo '/nfs_shared/dashboard 192.168.1.0/24(rw,sync,no_root_squash)'  >> /etc/exports
systemctl enable --now nfs