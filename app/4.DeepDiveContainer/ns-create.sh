#!/usr/bin/env bash
yum install -y bridge-utils
brctl addbr nginx
ip link set nginx up
ip addr add 192.168.200.1/24 dev nginx
ip link add name vhost type veth peer name container
ip netns add ns-nginx
ip link set container netns ns-nginx
ip netns exec ns-nginx ip link set container name eth1
ip netns exec ns-nginx ip addr add 192.168.200.2/24 dev eth1
ip netns exec ns-nginx ip link set eth1 up
ip netns exec ns-nginx ip route add default via 192.168.200.1
ip link set vhost up
brctl addif nginx vhost