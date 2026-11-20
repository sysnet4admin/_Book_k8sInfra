#!/usr/bin/env bash

REPO=~/gitops
SRC=~/_Book_k8sInfra/ch5/5.5.1
APP=~/_Book_k8sInfra/ch7/7.4.2/app-gitops-nginx.yaml
MSG="${1:-init commit}"

echo "Copy manifests from $SRC into ~/gitops."
cp "$SRC"/*.yaml "$REPO"/
ls "$REPO"

git -C "$REPO" add .
git -C "$REPO" commit -m "$MSG"
git -C "$REPO" push

REPO_URL="$(git -C "$REPO" remote get-url origin | sed 's/\.git$//')"
echo "Set repoURL: $REPO_URL"
yq e -i ".spec.source.repoURL = \"$REPO_URL\"" "$APP"

echo "Apply Argo CD Application."
kubectl apply -f "$APP"
