#!/usr/bin/env bash
ip netns delete ns-nginx
ip link delete nginx
ip link delete vhost
yum erase bridge-utils -y