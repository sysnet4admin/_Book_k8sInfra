#!/usr/bin/env bash

if [[ "$(uname -m)" =~ ^(arm64|aarch64)$ ]]; then
  ARCH="arm64"
else
  ARCH="amd64"
fi

echo "Install Argo Rollouts controller."
kubectl apply -n cicd \
  -f ~/_Book_k8sInfra/ch7/7.4.3/argo-rollouts.yaml

echo "Wait for Argo Rollouts controller to be ready..."
kubectl rollout status deployment/argo-rollouts -n cicd --timeout=120s

echo "Install kubectl argo rollouts plugin."
curl -sLo /usr/local/bin/kubectl-argo-rollouts \
  https://github.com/argoproj/argo-rollouts/releases/download/v1.7.2/kubectl-argo-rollouts-linux-${ARCH}
chmod +x /usr/local/bin/kubectl-argo-rollouts

PLUGIN_VER="$(kubectl argo rollouts version --short 2>/dev/null)"
echo ""
echo "Argo Rollouts controller installed."
echo "kubectl argo rollouts plugin: $PLUGIN_VER"
