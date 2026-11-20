#!/usr/bin/env bash

echo "Deploy prometheus-stack to monitoring namespace."
helm install prometheus-stack edu/kube-prometheus-stack \
  --namespace=monitoring \
  --create-namespace \
  -f $HOME/_Book_k8sInfra/ch7/7.2.3/prometheus-operator-values.yaml

