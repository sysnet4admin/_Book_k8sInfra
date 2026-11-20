#!/usr/bin/env bash

REPO=~/gitops
APP=~/_Book_k8sInfra/ch7/7.4.2/app-gitops-nginx.yaml
MSG="${1:-del gitops-nginx deployment}"

echo "Delete deployment.yaml from ~/gitops."
rm "$REPO/deployment.yaml"
ls "$REPO"

git -C "$REPO" add .
git -C "$REPO" commit -m "$MSG"
git -C "$REPO" push

echo "Refresh Argo CD so it prunes the deployment."
kubectl annotate application app-gitops-nginx -n cicd argocd.argoproj.io/refresh=hard --overwrite
kubectl wait --for=delete deployment/gitops-nginx -n default --timeout=60s

echo "Delete Argo CD Application."
kubectl delete -f "$APP"
