#!/usr/bin/env bash

helm install csi-nfs-release edu/csi-driver-nfs \
--namespace kube-system \
--set storageClass.create=true \
--set storageClass.name='managed-nfs-storage' \
--set storageClass.parameters.server='192.168.1.10' \
--set storageClass.parameters.share='/nfs_shared/dynamic-vol' \
--set storageClass.reclaimPolicy=Delete \
--set storageClass.volumeBindingMode=Immediate \
--set 'storageClass.mountOptions[0]=nfsvers=4.1' \
--set storageClass.parameters.mountPermissions='0777'
