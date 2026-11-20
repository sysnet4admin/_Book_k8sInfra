#!/usr/bin/env bash
shopt -s nullglob

# Deploy the base sLLM models (3.5GB workers) from models/base/.
MODEL_DIR="$HOME/_Book_k8sInfra/ch7/7.5.2/models/base"

echo "Deploy sLLM models."
for yaml_file in "$MODEL_DIR"/*-ollama.yaml; do
  kubectl apply -f "$yaml_file"
done

echo "Wait for sLLM models to be ready..."
for yaml_file in "$MODEL_DIR"/*-ollama.yaml; do
  deploy_name=$(awk '/^kind: Deployment/{found=1} found && /^  name:/{print $2; exit}' "$yaml_file")
  [ -n "$deploy_name" ] && kubectl rollout status deployment/"$deploy_name" --timeout=1800s
done
