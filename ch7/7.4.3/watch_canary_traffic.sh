#!/usr/bin/env bash
set -uo pipefail

DUR="${1:-30}"

# Colors (파이프/NO_COLOR 시 자동 비활성화).
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RST=$'\033[0m'
  GREEN=$'\033[32m'; YEL=$'\033[33m'; RED=$'\033[31m'; INV=$'\033[7m'
else
  BOLD=; DIM=; RST=; GREEN=; YEL=; RED=; INV=
fi

step()      { printf '\n%s %s %s\n' "${INV}${BOLD}${YEL}" "$1" "${RST}"; }
step_ok()   { printf '\n%s %s %s\n' "${INV}${BOLD}${GREEN}" "$1" "${RST}"; }
step_warn() { printf '\n%s %s %s\n' "${INV}${BOLD}${RED}" "$1" "${RST}"; }
note()      { printf '  %s%s%s\n' "${DIM}" "$1" "${RST}"; }
# 명령 출력을 dim "| " 블록으로 감싸 결과를 별도 블록으로 보여줌.
_emit() {
  printf '\n'
  eval "$1" 2>&1 | while IFS= read -r _line; do
    printf '  %s|%s %s\n' "${DIM}" "${RST}" "$_line"
  done
}
# show "<표시용 명령>" "<실제 실행 명령>" : 명령을 보여주고 -> 바로 실행 -> 결과 프레이밍 (Enter 대기 없음)
show() {
  printf '\n  %s>%s %s\n' "${BOLD}${GREEN}" "${RST}" "$1"
  _emit "$2"
}
# run_action: 빨간 > - Enter로 멈추는 유일한 단계(클러스터 상태를 바꾸는 promote).
run_action() {
  printf '\n  %s>%s %s\n' "${BOLD}${RED}" "${RST}" "$1"
  printf '    %sEnter 를 눌러 카나리 배포 재개 / press Enter to resume the canary rollout%s ' "${DIM}" "${RST}"
  IFS= read -r _
  _emit "$2"
}

# 트래픽이 어디서 어디로 가는지 먼저 안내 (항상 출력).
step "[flow] 트래픽 흐름 구성도"
note "web-client x10  --curl:80-->  Service 'canary'  --:3000-->  Pod ro-canary"
note "                                                            |- stable (dashboard:canary-v1)"
note "                                                            \- canary (dashboard:canary-v2)"
note "web-client 가 매초 'curl http://canary' 호출(--no-keepalive: 요청 1건 = 연결 1건 = SYN 1개)."
note "서비스 뒤에 stable/canary 두 버전이 공존하고, 가중치는 파드 개수 비율로 근사됩니다."
note "아래 측정은 위 흐름의 최종 도착지인 카나리 대상 파드가 수신하는 패킷(SYN)을 버전(stable/canary)별로 세어 카나리 트래픽 비율을 보여줍니다."

# 부하 생성기가 없으면 배포.
if [ -z "$(kubectl get pods -l app=web-client -o name 2>/dev/null)" ]; then
  step "[setup] 부하 생성기(web-client) 배포"
  show "kubectl apply -f po-web-clients.yaml  (+ Ready 대기)" \
       "kubectl apply -f \"\$HOME/_Book_k8sInfra/ch7/7.4.3/po-web-clients.yaml\" && kubectl wait --for=condition=Ready pod -l app=web-client --timeout=120s"
fi

CIL="$(kubectl get pod -n kube-system -l k8s-app=cilium -o jsonpath='{.items[0].metadata.name}')"
RELAY="$(kubectl get svc -n kube-system hubble-relay -o jsonpath='{.spec.clusterIP}')"
CANARY_HASH="$(kubectl get rollout ro-canary -o jsonpath='{.status.currentPodHash}')"
STABLE_HASH="$(kubectl get rollout ro-canary -o jsonpath='{.status.stableRS}')"

# step index $1 시점의 마지막 setWeight.
step_weight() {
  local cur="$1" i=0 w="" v
  while [ "$i" -le "$cur" ]; do
    v="$(kubectl get rollout ro-canary -o jsonpath="{.spec.strategy.canary.steps[$i].setWeight}" 2>/dev/null)"
    [ -n "$v" ] && w="$v"
    i=$((i+1))
  done
  echo "$w"
}

# 연결당 1개인 to-endpoint SYN만 집계, ReplicaSet 별로 그룹화.
measure() {
  kubectl exec -n kube-system "$CIL" -c cilium-agent -- \
    timeout "$DUR" hubble observe -f --server "$RELAY":80 \
      --to-label app=ro-canary --to-port 3000 --tcp-flags SYN -o compact 2>/dev/null \
    | grep 'to-endpoint' \
    | grep -oE 'ro-canary-[a-z0-9]+-[a-z0-9]+' \
    | sed -E 's/ro-canary-([a-z0-9]+)-[a-z0-9]+/\1/' \
    | sort | uniq -c \
    | awk -v c="$CANARY_HASH" -v s="$STABLE_HASH" '
        {cnt[$2]=$1; tot+=$1}
        END{
          cc=cnt[c]+0; ss=cnt[s]+0;
          printf "  canary=%d  stable=%d  total=%d\n", cc, ss, tot;
          if(tot>0) printf "  measured canary traffic ratio = %.1f%%\n", 100.0*cc/tot;
        }'
}

if [ "$CANARY_HASH" = "$STABLE_HASH" ]; then
  step_warn "[idle] 진행 중인 카나리가 없습니다"
  note "카나리 배포를 실행하기 위해 아래 명령을 수행해주세요:"
  note "  kubectl argo rollouts set image ro-canary dashboard=sysnet4admin/dashboard:canary-v2"
  exit 0
fi

step "[start] 카나리 진행 감지"
note "canary replicaset=$CANARY_HASH  stable replicaset=$STABLE_HASH"

measured=" "
while true; do
  PHASE="$(kubectl get rollout ro-canary -o jsonpath='{.status.phase}')"
  STEP="$(kubectl get rollout ro-canary -o jsonpath='{.status.currentStepIndex}')"

  case "$PHASE" in
    Healthy|Degraded)
      step_ok "[done] Rollout $PHASE."
      break
      ;;
    Paused)
      case "$measured" in
        *" $STEP "*) ;;
        *)
          W="$(step_weight "$STEP")"
          PAUSE_DUR="$(kubectl get rollout ro-canary -o jsonpath="{.spec.strategy.canary.steps[$STEP].pause.duration}" 2>/dev/null)"
          step "[measure] setWeight ${W:-?}% (paused) - ${DUR}s 측정"
          show "hubble observe --to-label app=ro-canary --tcp-flags SYN   ${GREEN}# 카나리 vs 안정 연결 수 집계${RST}" \
               "measure"
          measured="$measured$STEP "
          # 무기한 pause만 수동 promote 대기; duration pause는 자동 진행.
          if [ -z "$PAUSE_DUR" ]; then
            run_action "kubectl argo rollouts promote ro-canary   ${GREEN}# 카나리 배포 재개${RST}" \
                       "kubectl argo rollouts promote ro-canary"
          fi
          ;;
      esac
      ;;
  esac
  sleep 3
done
