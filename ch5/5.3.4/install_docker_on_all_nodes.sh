#!/usr/bin/env bash

NODE_COUNT=3

for (( i=1; i<=$NODE_COUNT; i++ ));
  do
  TARGET="192.168.1.10$i"
  echo "[Step $i/3] Installing docker on $TARGET"
  sshpass -p vagrant scp -o StrictHostKeyChecking=no -q ~/_Book_k8sInfra/ch4/4.2.1/install_docker.sh root@$TARGET:/tmp
  sshpass -p vagrant ssh root@$TARGET bash /tmp/install_docker.sh > /dev/null 2>&1
  sshpass -p vagrant ssh root@$TARGET chmod 666 /var/run/docker.sock 2>&1
  done
echo "Successfully completed"
