#!/usr/bin/env bash
certdir=/etc/docker/certs.d/192.168.1.10:8443
mkdir /data
mkdir -p $certdir
openssl req -x509 -nodes -newkey rsa:4096 -keyout tls.key -out tls.crt -days 365 \
-config tls.csr -extensions v3_req
cp tls.crt $certdir
yum install sshpass -y 
for i in {1..3}
  do
    sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.1.10$i mkdir -p $certdir
    sshpass -p vagrant scp tls.crt 192.168.1.10$i:$certdir
  done

docker run -d \
  --restart=always \
  --name registry \
  -v /root/IaC/Docker/Registry:/certs:ro \
  -v /data:/var/lib/registry \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/tls.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/tls.key \
  -p 8443:443 \
  registry:2