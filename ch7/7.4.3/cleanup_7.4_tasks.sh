#!/usr/bin/env bash

echo "🧹 [7.4] 아르고 CD / 아르고 롤아웃 실습 리소스 정리"

# 7.4.3 카나리 Rollout 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.4.3/ro-canary.yaml 2>/dev/null

# 7.4.3 블루그린 Rollout 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.4.3/ro-bluegreen.yaml 2>/dev/null

# 7.4.3 트래픽 측정용 web-client 파드 삭제
kubectl delete -f $HOME/_Book_k8sInfra/ch7/7.4.3/po-web-clients.yaml 2>/dev/null

# 7.4.2 ArgoCD 애플리케이션 삭제(컨트롤러가 있을 때 지운다)
kubectl delete applications.argoproj.io --all -n cicd >/dev/null 2>&1

# 7.4.2 ArgoCD / 7.4.3 Argo Rollouts 삭제
kubectl delete namespace cicd 2>/dev/null

# 7.4.2 ArgoCD / 7.4.3 Argo Rollouts의 CRD, ClusterRole, ClusterRoleBinding 삭제(네임스페이스를 지워도 남는다)
kubectl delete -n cicd -f $HOME/_Book_k8sInfra/ch7/7.4.3/argo-rollouts.yaml --ignore-not-found >/dev/null 2>&1
kubectl delete -n cicd -f $HOME/_Book_k8sInfra/ch7/7.4.2/argocd.yaml --ignore-not-found >/dev/null 2>&1

echo "✅ 7.4 cleanup done."
