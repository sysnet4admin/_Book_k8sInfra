#!/usr/bin/env bash

echo "🧹 [7.1] 쿠버네티스 대시보드 / 헤드램프 실습 리소스 정리"

# 7.1.3 RBAC viewer 리소스
kubectl delete clusterrolebinding viewer-binding 2>/dev/null
kubectl delete serviceaccount viewer -n default 2>/dev/null
kubectl config delete-context viewer-context 2>/dev/null
kubectl config delete-user viewer-user 2>/dev/null

# 7.1.3 헤드램프로 배포한 디플로이먼트
kubectl delete deployment nginx-by-headlamp 2>/dev/null

# 7.1.2 대시보드로 배포한 디플로이먼트
kubectl delete deployment nginx-by-k8s-dash 2>/dev/null

# 7.1.2 쿠버네티스 대시보드 전체 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.1.2/kubernetes-dashboard.yaml 2>/dev/null

echo "✅ 7.1 cleanup done."
