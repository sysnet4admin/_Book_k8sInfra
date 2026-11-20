#!/usr/bin/env bash

echo "🧹 [7.2] 실리움 네트워크 정책 / 프로메테우스 오퍼레이터 실습 리소스 정리"

# 7.2.3 프로메테우스 스택 삭제
helm uninstall prometheus-stack --namespace=monitoring 2>/dev/null

# 7.2.3 프로메테우스 PVC 삭제
kubectl delete pvc -n monitoring -l operator.prometheus.io/name=prometheus-stack-kube-prom-prometheus 2>/dev/null

# 7.2.3 monitoring 네임스페이스 삭제
kubectl delete namespace monitoring 2>/dev/null

# 7.2.2 tier ping relay 리소스 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.2.2/po-tier-ping-relay.yaml 2>/dev/null

# 7.2.2 실리움 네트워크 정책 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.2.2/cnp-allow-icmp-ping.yaml 2>/dev/null

# 7.2.2 tier 파드 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.2.2/po-tiers.yaml 2>/dev/null

echo "✅ 7.2 cleanup done."
