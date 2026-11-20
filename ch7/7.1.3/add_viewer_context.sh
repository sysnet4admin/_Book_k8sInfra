#!/usr/bin/env bash

# Create viewer ServiceAccount and bind view ClusterRole
kubectl create serviceaccount viewer -n default
kubectl create clusterrolebinding viewer-binding \
  --clusterrole=view \
  --serviceaccount=default:viewer

# Create long-lived token and register as kubeconfig credentials + context
TOKEN=$(kubectl create token viewer -n default --duration=87600h)
kubectl config set-credentials viewer-user --token="$TOKEN"
kubectl config set-context viewer-context \
  --cluster=kubernetes \
  --user=viewer-user

echo "viewer-context added to kubeconfig."
