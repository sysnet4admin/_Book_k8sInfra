#!/usr/bin/env bash

echo "🧹 [7.3] 예거 / 오픈텔레메트리 콜렉터 / HotROD / 그라파나 / 템포 실습 리소스 정리"

# 7.3.3 그라파나 스택 helm release 삭제
helm uninstall grafana --namespace=monitoring 2>/dev/null

# 7.3.3 그라파나 PVC 삭제
kubectl delete pvc -n monitoring -l app.kubernetes.io/name=grafana 2>/dev/null

# 7.3.3 템포 PVC 삭제
kubectl delete pvc -n monitoring -l app.kubernetes.io/name=tempo 2>/dev/null

# 7.3.2 OTel 컬렉터 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.3.2/otel-collector.yaml 2>/dev/null

# 7.3.2 핫로드 앱 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.3.2/hotrod-via-otel-collector.yaml 2>/dev/null

# 7.3.2 예거 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.3.2/jaeger-all-in-one.yaml 2>/dev/null

# monitoring 네임스페이스 삭제
kubectl delete namespace monitoring 2>/dev/null

echo "✅ 7.3 cleanup done."
