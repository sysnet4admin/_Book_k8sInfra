#!/bin/bash
deploy_func="kubectl get deployments -o jsonpath --template={.items[0].status.readyReplicas}"
while true; do
  green_ready=$($deploy_func --selector=app=dashboard,deploy=green 2> /dev/null)
  blue_ready=$($deploy_func --selector=app=dashboard,deploy=blue 2> /dev/null)
  echo "green: $green_ready / blue: $blue_ready"
  sleep 1;
done