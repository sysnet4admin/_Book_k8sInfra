#!/usr/bin/env bash
kgd_out="kubectl get deployments -o jsonpath --template={.items[0].status.readyReplicas}"
while true; do
  blue_ready=$($kgd_out --selector=deploy=blue 2> /dev/null)
  green_ready=$($kgd_out --selector=deploy=green 2> /dev/null)
  echo "blue: $blue_ready / green: $green_ready"
  sleep 1
done