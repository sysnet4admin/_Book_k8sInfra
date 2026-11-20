#!/usr/bin/env bash
apt-get install -y bridge-utils
brctl addbr br-nginx
ip link set br-nginx up
ip addr add 192.168.200.1/24 dev br-nginx
ip link add name h-int type veth peer name c-int
ip netns add ns-nginx
ip link set c-int netns ns-nginx
ip netns exec ns-nginx ip link set c-int name eth1
ip netns exec ns-nginx ip addr add 192.168.200.2/24 dev eth1
ip netns exec ns-nginx ip link set eth1 up
ip netns exec ns-nginx ip route add default via 192.168.200.1
ip link set h-int up
brctl addif br-nginx h-int
