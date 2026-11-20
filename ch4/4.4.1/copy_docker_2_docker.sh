#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: copy_docker_2_docker.sh <node-name>"; exit 0
fi

DOCKER_NAMESPACE="moby"
KUBERNETES_NAMESPACE="k8s.io"
TEMP_DOCKER_FILE_PATH=/tmp/docker-multistage-img.tar

echo "[Step 1/4] Install necessary packages, export docker image(multistage-img) as tar format from cp-k8s"
apt-get install sshpass -y > /dev/null 2>&1
sshpass -p vagrant scp -o StrictHostKeyChecking=no -q  ~/_Book_k8sInfra/ch4/4.2.1/install_docker.sh root@$1:/tmp
sshpass -p vagrant ssh root@$1 bash /tmp/install_docker.sh > /dev/null 2>&1
docker save multistage-img -o $TEMP_DOCKER_FILE_PATH || exit 1 

echo "[Step 2/4] Send 'docker-multistage-img.tar' file to $1 node"
sshpass -p vagrant scp -o StrictHostKeyChecking=no -q $TEMP_DOCKER_FILE_PATH root@$1:$TEMP_DOCKER_FILE_PATH

echo "[Step 3/4] Load 'docker-multistage-img.tar' in $1 node's Docker namespace($DOCKER_NAMESPACE)"
sshpass -p vagrant ssh root@$1 docker load -i $TEMP_DOCKER_FILE_PATH

echo -e "[Step 4/4] Successfully completed \nCHECK PURPOSE: Run 'kubectl get pods' again"
