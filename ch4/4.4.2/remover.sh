#!/usr/bin/env bash
certs=/etc/docker/certs.d/192.168.1.10:8443
rm -rf /registry-image
rm -rf /etc/docker/certs
rm -rf $certs

yum -y install sshpass
for i in {1..3}
  do
    sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.1.10$i rm -rf $certs
  done

yum remove sshpass -y
docker rm -f registry
docker rmi registry:2
