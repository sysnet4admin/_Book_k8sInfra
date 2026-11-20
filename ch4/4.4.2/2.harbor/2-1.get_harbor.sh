#!/usr/bin/env bash
HARBOR_FILE_DIR=/opt/harbor
HARBOR_DATA_DIR=/data/harbor
HARBOR_VERSION=v2.10.0
echo "Remove existing configuration files"
rm -f 2-3.prepare 2-4.install.sh common.sh LICENSE

echo "Create Harbor data directory($HARBOR_DATA_DIR)"
mkdir -p $HARBOR_DATA_DIR

echo "Download harbor-online-installer-${HARBOR_VERSION}..."
curl -LO https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer-${HARBOR_VERSION}.tgz
tar -xvf harbor-online-installer-${HARBOR_VERSION}.tgz
mv harbor/* .

echo "Remove garbage files"
rm -f harbor-online-installer-${HARBOR_VERSION}.tgz
rm -rf harbor

echo "Add sequence number: "
echo "prepare    >>> 2-3.prepare"
echo "install.sh >>> 2-4.install.sh"
mv prepare 2-3.prepare
mv install.sh 2-4.install.sh

# modify 2-3.prepare.sh
sed -i '3 i\\HARBOR_BUNDLE_DIR=/opt/harbor' 2-3.prepare

# modify 2-4.install.sh
sed -i '/prepare $prepare_para/d' 2-4.install.sh
sed -i 's,$DOCKER_COMPOSE,$DOCKER_COMPOSE -f /opt/harbor/docker-compose.yml,' 2-4.install.sh
sed -i 's/up -d/-p harbor up -d/' 2-4.install.sh

# for arm64/aarch64 — use sysnet4admin arm64 images (built via _image-builder/build.sh)
# The prepare image bakes only VERSION_TAG (${HARBOR_VERSION}-arm64) into the generated
# docker-compose.yml; the goharbor/ namespace is hardcoded in its jinja template,
# so it must be substituted after generation. Do NOT add a tag sed here —
# tags already come out as -arm64 and would become -arm64-arm64.
# NOTE: requires sysnet4admin/*:${HARBOR_VERSION}-arm64 images to exist on Docker
# Hub — rebuild via _image-builder/build.sh if this HARBOR_VERSION changes.
if [ "$(uname -m)" == "aarch64" ]; then
  echo "arm64 detected — switching to sysnet4admin/prepare:${HARBOR_VERSION}-arm64"
  sed -i "s,goharbor/prepare:${HARBOR_VERSION},sysnet4admin/prepare:${HARBOR_VERSION}-arm64,gi" 2-3.prepare
  echo '
sed -i "s,goharbor/,sysnet4admin/,gi" /opt/harbor/docker-compose.yml' >> 2-3.prepare
fi

# create systemd startup service for Harbor
cat <<EOF > /usr/lib/systemd/system/harbor.service
[Unit]
Description=Harbor startup service
Requires=docker.service
ConditionPathExists=$HARBOR_FILE_DIR/docker-compose.yml
After=network.target systemd-networkd-wait-online.service systemd-resolved.service syslog.service docker.service
Wants=network.target systemd-networkd-wait-online.service systemd-resolved.service syslog.service docker.service

[Service]
Type=simple
ExecStart=/usr/bin/docker compose -f $HARBOR_FILE_DIR/docker-compose.yml up
ExecStop=/usr/bin/docker compose -f $HARBOR_FILE_DIR/docker-compose.yml down

[Install]
WantedBy=multi-user.target
EOF

# reload and enable systemd service
systemctl daemon-reload
systemctl enable harbor
