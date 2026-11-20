#!/usr/bin/env bash

CRI_NAME="d2c"
IMG_NAME="multistage-img"

echo "[Step 1/5] Delete deployment $CRI_NAME"
kubectl delete deployment $CRI_NAME 

echo "[Step 2/5] Uninstall packages, Delete docker & containerd images in w1-k8s"
sshpass -p vagrant ssh root@w1-k8s docker rmi $IMG_NAME    > /dev/null 2>&1
sshpass -p vagrant ssh root@w1-k8s crictl rmi $IMG_NAME    > /dev/null 2>&1
sshpass -p vagrant ssh root@w1-k8s apt-get purge docker-ce > /dev/null 2>&1

echo "[Step 3/5] Uninstall packages, Delete docker & containerd images in w2-k8s"
sshpass -p vagrant ssh root@w2-k8s docker rmi $IMG_NAME    > /dev/null 2>&1
sshpass -p vagrant ssh root@w2-k8s crictl rmi $IMG_NAME    > /dev/null 2>&1
sshpass -p vagrant ssh root@w2-k8s apt-get purge docker-ce > /dev/null 2>&1

echo "[Step 4/5] Uninstall packages, Delete docker & containerd images in w3-k8s"
sshpass -p vagrant ssh root@w3-k8s docker rmi $IMG_NAME    > /dev/null 2>&1
sshpass -p vagrant ssh root@w3-k8s crictl rmi $IMG_NAME    > /dev/null 2>&1
sshpass -p vagrant ssh root@w3-k8s apt-get purge docker-ce > /dev/null 2>&1

echo "[Step 5/5] Successfully completed"
