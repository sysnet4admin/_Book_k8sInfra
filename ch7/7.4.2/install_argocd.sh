#!/usr/bin/env bash

echo "Deploy ArgoCD to cicd namespace."
kubectl create ns cicd --save-config
kubectl apply --server-side --force-conflicts -n cicd \
  -f $HOME/_Book_k8sInfra/ch7/7.4.2/argocd.yaml

echo "Wait for ArgoCD to be ready..."
kubectl rollout status deployment/argocd-server -n cicd --timeout=180s

PASSWORD="$(kubectl get secret -n cicd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)"
ENDPOINT="$(kubectl get service argocd-server -n cicd -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"

echo ""
echo "ArgoCD UI:      https://$ENDPOINT"
echo "Admin password: $PASSWORD"
