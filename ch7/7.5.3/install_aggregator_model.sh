#!/usr/bin/env bash
shopt -s nullglob

# Deploy the aggregator model (gemma4:12b-it-qat) onto w4-k8s from models/.
# Run this on cp-k8s after `vagrant up w4-k8s-1.36.1` (host, add-node4/) has
# joined w4-k8s to the cluster.
MODEL_DIR="$HOME/_Book_k8sInfra/ch7/7.5.3/models"

echo "Deploy aggregator model on w4-k8s."
for yaml_file in "$MODEL_DIR"/*-ollama.yaml; do
  kubectl apply -f "$yaml_file"
done

echo "Wait for aggregator model to be ready..."
for yaml_file in "$MODEL_DIR"/*-ollama.yaml; do
  deploy_name=$(awk '/^kind: Deployment/{found=1} found && /^  name:/{print $2; exit}' "$yaml_file")
  [ -n "$deploy_name" ] && kubectl rollout status deployment/"$deploy_name" --timeout=3600s
done
