#!/usr/bin/env bash

HARBOR_TEMPLATE=harbor.yml.tmpl
HARBOR_PREPARE=/opt/harbor/harbor.yml 

echo "Modify $HARBOR_TEMPLATE to prepare the Harbor"
sed -i 's/hostname: reg.mydomain.com/hostname: 192.168.1.10/' \
       $HARBOR_TEMPLATE
sed -i 's/port: 443/port: 8443/' \
       $HARBOR_TEMPLATE
sed -i 's,certificate: /your/certificate/path,certificate: /opt/harbor/server.crt,' \
       $HARBOR_TEMPLATE
sed -i 's,private_key: /your/private/key/path,private_key: /opt/harbor/server.key,' \
       $HARBOR_TEMPLATE
sed -i 's/harbor_admin_password: Harbor12345/harbor_admin_password: admin/' \
       $HARBOR_TEMPLATE
sed -i 's,data_volume: /data,data_volume: /data/harbor,' \
       $HARBOR_TEMPLATE

echo "Overwrite modified $HARBOR_TEMPLATE to $HARBOR_PREPARE"
mv $HARBOR_TEMPLATE $HARBOR_PREPARE

echo "Successfully completed"
