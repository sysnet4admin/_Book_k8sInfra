#!/usr/bin/env bash

echo "Deploy Grafana and Tempo to monitoring namespace."
helm install grafana edu/grafana-stack \
  --namespace monitoring \
  --create-namespace \
  -f $HOME/_Book_k8sInfra/ch7/7.3.3/grafana-tempo-values.yaml

echo "Wait for Grafana to be ready..."
kubectl rollout status deployment/grafana \
  -n monitoring --timeout=180s

echo "Wait for Tempo to be ready..."
kubectl rollout status statefulset/grafana-tempo \
  -n monitoring --timeout=180s

GRAFANA_IP="$(kubectl get svc grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"

echo "Provisioning Tempo datasource..."
until curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  "http://$GRAFANA_IP/api/datasources" \
  -d '{
    "name": "Tempo",
    "type": "tempo",
    "url": "http://grafana-tempo.monitoring.svc.cluster.local:3200",
    "access": "proxy",
    "isDefault": false
  }' | grep -q "^200$"; do
  echo "Grafana not ready, retrying in 10s..."
  sleep 10
done

echo ""
echo "Grafana available at http://$GRAFANA_IP"
echo "Tempo OTLP endpoint: grafana-tempo.monitoring.svc.cluster.local:4317"
