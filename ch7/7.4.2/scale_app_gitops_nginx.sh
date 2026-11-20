#!/usr/bin/env bash

REPO=~/gitops
FILE="$REPO/deployment.yaml"
MSG="${1:-chg replicas number}"

echo "Change replicas 2 -> 5 in deployment.yaml."
sed -i 's/replicas: 2/replicas: 5/' "$FILE"
grep -n "replicas:" "$FILE"

git -C "$REPO" add .
git -C "$REPO" commit -m "$MSG"
git -C "$REPO" push
