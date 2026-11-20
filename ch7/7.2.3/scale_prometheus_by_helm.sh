#!/usr/bin/env bash

DESIRED=2

CURRENT=$(kubectl get prometheus -n monitoring -o jsonpath='{.items[0].spec.replicas}')
CURRENT=${CURRENT:-1}

echo "Scale Prometheus replicas from ${CURRENT} to ${DESIRED}."
helm upgrade prometheus-stack edu/kube-prometheus-stack \
  --namespace=monitoring \
  -f $HOME/_Book_k8sInfra/ch7/7.2.3/prometheus-operator-values.yaml \
  --set prometheus.prometheusSpec.replicas=${DESIRED}
