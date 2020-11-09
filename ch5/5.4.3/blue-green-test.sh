#!/bin/bash
kgd_out="kubectl get deployments -o jsonpath --template={.items[0].status.readyReplicas}"
while true; do
  green_ready=$($kgd_out --selector=app=dashboard,deploy=green 2> /dev/null)
  blue_ready=$($dkgd_out --selector=app=dashboard,deploy=blue 2> /dev/null)
  echo "blue: $blue_ready / green: $green_ready"
  sleep 1;
done
