#!/usr/bin/env bash

kubectl create ns monitoring --save-config
echo "Deploy otel-collector to monitoring namespace."
kubectl apply -f $HOME/_Book_k8sInfra/ch7/7.3.2/otel-collector.yaml

echo "Deploy Jaeger all-in-one to monitoring namespace."
kubectl apply -f $HOME/_Book_k8sInfra/ch7/7.3.2/jaeger-all-in-one.yaml

echo "Wait for Jaeger to be ready..."
kubectl rollout status deployment/jaeger -n monitoring --timeout=120s

echo "Deploy HotROD demo app."
kubectl apply -f $HOME/_Book_k8sInfra/ch7/7.3.2/hotrod-via-otel-collector.yaml

echo "Wait for HotROD to be ready..."
kubectl rollout status deployment/hotrod --timeout=120s

JAEGER_IP="$(kubectl get svc jaeger -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
HOTROD_IP="$(kubectl get svc hotrod -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"

echo ""
echo "Jaeger UI: http://$JAEGER_IP:16686"
echo "HotROD UI: http://$HOTROD_IP"
