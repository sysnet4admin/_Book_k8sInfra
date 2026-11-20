#!/usr/bin/env bash

TAG=v2.10.0
HARBOR_HOST=192.168.1.10:8443
HARBOR_FILE_DIR=/opt/harbor
HARBOR_DATA_DIR=/data/harbor
DOCKER_CERT_DIR=/etc/docker/certs.d/$HARBOR_HOST
HOST_CERT_DIR=/usr/local/share/ca-certificates

# initialize a variable to check for the presence of image preserve option
IMAGE_PRESERVE_OPTION=false

# iterate through all arguments passed to script
for arg in "$@"
do
  # when uninstalling, if script is run as './uninstall_harbor.sh --preserve-image', following image preserve option will be activated
  if [ "$arg" == "--preserve-image" ]; then
     IMAGE_PRESERVE_OPTION=true
     break;
  fi
done

echo "[Step 1/6] Stopping Harbor"
docker compose -f $HARBOR_FILE_DIR/docker-compose.yml down

echo "[Step 2/6] Remove Harbor & files"
# preserve initial scripts
mv ./2.harbor/2-1.get_harbor.sh .
mv ./2.harbor/2-2.modify_config.sh .
rm -rf ./2.harbor
mkdir 2.harbor
mv 2-1.get_harbor.sh ./2.harbor
mv 2-2.modify_config.sh ./2.harbor

echo "[Step 3/6] Removing Harbor images"
if [ "$IMAGE_PRESERVE_OPTION" = false ]; then
  if [ "$(uname -m)" == "aarch64" ]; then
    NS=sysnet4admin; TAG=${TAG}-arm64
  else
    NS=goharbor
  fi
  docker rmi -f $NS/redis-photon:$TAG \
  $NS/harbor-registryctl:$TAG \
  $NS/registry-photon:$TAG \
  $NS/nginx-photon:$TAG \
  $NS/harbor-log:$TAG \
  $NS/harbor-jobservice:$TAG \
  $NS/harbor-core:$TAG \
  $NS/harbor-portal:$TAG \
  $NS/harbor-db:$TAG \
  $NS/prepare:$TAG
  docker rmi -f $NS/harbor-exporter:$TAG 2>/dev/null || true
else
  echo "--preserve-image option is present, skip removing images"
fi

echo "[Step 4/6] Removing copied certificates"
for i in {1..3}
  do
    echo "Remove certificate on w$i-k8s"
    sshpass -p vagrant ssh -o StrictHostKeyChecking=no \
            root@192.168.1.10$i rm -rf $DOCKER_CERT_DIR
    sshpass -p vagrant ssh root@192.168.1.10$i \
            rm $HOST_CERT_DIR/harbor_ca.crt
    sshpass -p vagrant ssh root@192.168.1.10$i \
            update-ca-certificates -f
    sshpass -p vagrant ssh root@192.168.1.10$i \
            systemctl restart containerd
  done

echo "[Step 5/6] Remove copied key and certificate from others components"
rm -rf $HARBOR_FILE_DIR
rm -rf $HARBOR_DATA_DIR
rm -rf $DOCKER_CERT_DIR
rm -f $HOST_CERT_DIR/harbor_ca.crt

echo "[Step 6/6] Restart control plane to load the init environment"
update-ca-certificates -f
systemctl restart containerd
rm -f /etc/systemd/system/multi-user.target.wants/harbor.service /usr/lib/systemd/system/harbor.service /lib/systemd/system/harbor.service
systemctl daemon-reload
