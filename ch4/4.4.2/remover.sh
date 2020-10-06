#!/usr/bin/env bash
certdir=/etc/docker/certs.d/192.168.1.10:8443
rm -f tls.key tls.crt
rm -rf /data
rm -rf $certdir

yum -y install sshpass
for i in {1..3}
  do
    sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.1.10$i rm -rf $certdir
  done

yum remove sshpass -y
docker rm -f registry
docker rmi registry:2