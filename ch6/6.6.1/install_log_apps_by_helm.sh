#!/usr/bin/env bash
echo "[Step 1/3] Deploying Redis..."
helm install redis edu/redis \
--namespace colosseum \
--create-namespace > /dev/null 2>&1

kubectl -n colosseum wait deployment/redis --for=condition=available > /dev/null 2>&1
echo "Done"

echo "[Step 2/3] Deploying Colosseum app..."
helm install colosseum edu/colosseum \
--namespace colosseum \
--set monitoring.mode=log

echo "[Step 3/3] Deploying Load-generator..."
helm install load-generator edu/load-generator \
--namespace colosseum \
--create-namespace > /dev/null 2>&1

echo "Done"
