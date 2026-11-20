#!/usr/bin/env bash

echo "🧹 [7.4] 아르고 CD / 아르고 롤아웃 실습 리소스 정리"

# 7.4.3 카나리 Rollout 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.4.3/ro-canary.yaml 2>/dev/null

# 7.4.3 블루그린 Rollout 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.4.3/ro-bluegreen.yaml 2>/dev/null

# 7.4.3 트래픽 측정용 web-client 파드 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.4.3/po-web-clients.yaml 2>/dev/null

# 7.4.2 ArgoCD / 7.4.3 Argo Rollouts 삭제
kubectl delete namespace cicd 2>/dev/null

echo "✅ 7.4 cleanup done."
