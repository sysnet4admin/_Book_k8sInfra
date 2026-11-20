#!/usr/bin/env bash
ip netns delete ns-nginx
ip link delete br-nginx
apt-get remove bridge-utils -y
