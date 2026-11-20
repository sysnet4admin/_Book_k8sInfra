#!/bin/sh
spawn-fcgi -p 9001 -P /run/spawn-fcgi.pid -- /usr/bin/fcgiwrap -c 3;
./docker-entrypoint.sh nginx;
