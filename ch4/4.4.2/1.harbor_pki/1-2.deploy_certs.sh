#!/usr/bin/env bash

HARBOR_FILE_DIR=/opt/harbor
HARBOR_HOST=192.168.1.10:8443
DOCKER_CERT_DIR=/etc/docker/certs.d/$HARBOR_HOST
HOST_CERT_DIR=/usr/local/share/ca-certificates

# if 4.4.1 skipped, it should run. so add here. 
apt-get install sshpass -y > /dev/null 2>&1

echo "[Step 1/4] Create Docker certificate directory"
mkdir -p $DOCKER_CERT_DIR

echo "[Step 2/4] Copying certificate to each of worker nodes"
for i in {1..3}
  do
    echo "Copy to node w$i-k8s"
    sshpass -p vagrant scp -o StrictHostKeyChecking=no \
	    $HARBOR_FILE_DIR/ca.crt 192.168.1.10$i:$HOST_CERT_DIR/harbor_ca.crt
    sshpass -p vagrant ssh root@192.168.1.10$i \
	    update-ca-certificates 
    sshpass -p vagrant ssh root@192.168.1.10$i \
	    systemctl restart containerd
  done

echo "[Step 3/4] Copy certificate to control plane"
cp -f $HARBOR_FILE_DIR/ca.crt $DOCKER_CERT_DIR/ca.crt
cp -f $HARBOR_FILE_DIR/ca.crt $HOST_CERT_DIR/harbor_ca.crt

echo "[Step 4/4] Update certificate list and restart containerd"
update-ca-certificates 
systemctl restart containerd
