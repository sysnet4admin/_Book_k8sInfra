# 7.4.3 Argo Rollouts: 블루그린(Blue-Green)과 카나리(Canary) 배포

## 목표
- 블루그린 배포: preview 서비스로 새 버전을 확인한 뒤 승격(promote)해 active 서비스로 전환
- 카나리 배포: 트래픽을 25→50→75→100%로 단계적으로 새 버전으로 이동

## 사전 조건
- 7.4.2에서 만든 cicd 네임스페이스 (아르고 롤아웃 컨트롤러가 여기에 설치됨)

## 실습 파일
- `install_argo_rollouts.sh`: 아르고 롤아웃 컨트롤러(cicd 네임스페이스)와 kubectl 플러그인 설치
- `argo-rollouts.yaml`: 아르고 롤아웃 컨트롤러 매니페스트 (v1.7.2)
- `ro-bluegreen.yaml`: 블루그린 Rollout과 서비스(bluegreen-active, bluegreen-preview)
- `ro-canary.yaml`: 카나리 Rollout과 서비스(canary)
- `po-web-clients.yaml`: 트래픽 측정용 web-client 파드
- `watch_canary_traffic.sh`: 트래픽을 발생시켜 버전별 응답 비율을 보여 주고 단계별 승격 진행
- `cleanup_7.4_tasks.sh`: 7.4절 실습 리소스 정리

## 실습 순서
1. `bash 7.4.3/install_argo_rollouts.sh`로 컨트롤러와 플러그인 설치
2. `k apply -f 7.4.3/ro-bluegreen.yaml`로 블루그린 Rollout 배포
3. `k argo rollouts set image ro-bluegreen dashboard=sysnet4admin/dashboard:green`으로 새 버전 배포 후 preview 확인
4. `k argo rollouts promote ro-bluegreen`으로 승격
5. `k apply -f 7.4.3/ro-canary.yaml`로 카나리 Rollout 배포
6. `k argo rollouts set image ro-canary dashboard=sysnet4admin/dashboard:canary-v2`로 카나리 시작
7. `bash 7.4.3/watch_canary_traffic.sh`로 트래픽 비율 확인과 단계별 승격
8. `bash 7.4.3/cleanup_7.4_tasks.sh`로 정리
