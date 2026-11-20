#!/usr/bin/env bash
echo "[Step 1/4] Uninstalling Load-generator..."
helm uninstall  load-generator \
--namespace colosseum 

echo "[Step 2/4] Uninstalling Colosseum app..."
helm uninstall colosseum \
--namespace colosseum 

echo "[Step 3/4] Uninstalling Redis..."
helm uninstall redis \
--namespace colosseum 

echo "[Step 4/4] Deleting colosseum namespace..."
kubectl delete namespace colosseum
