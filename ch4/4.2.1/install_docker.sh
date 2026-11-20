#!/usr/bin/env bash

# Docker version
docker_V='5:26.0.0-1~ubuntu.24.04~noble'
buildx_V='0.13.1-1~ubuntu.24.04~noble'
compose_V='2.25.0-1~ubuntu.24.04~noble'

# install & enable docker 
apt-get update 
apt-get install docker-ce=$docker_V \
                docker-ce-cli=$docker_V \
                docker-ce-rootless-extras=$docker_V \
                docker-buildx-plugin=$buildx_V \
                docker-compose-plugin=$compose_V  -y
