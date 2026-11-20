#!/usr/bin/env bash
# 7.5.3 - 대화형 에이전트 혼합 기법(MoA): 제안자 모델들에 질의 -> 정제 모델이 답변 정제 -> 결과 출력
#   정제 전용 모델(서비스명 ollama-agg-*)은 1단계 제안에서 제외되고 정제 모델 선택지에만 오른다.
set -uo pipefail

echo "에이전트 혼합 기법 대화형 콘솔"
echo "================================================"
echo "배포된 소형 LLM 여러 개에 질문을 보내고 정제 모델이 답변을 정제합니다."

# fzf 가 없으면 설치 (클러스터 노드 = 고정 Ubuntu/apt). 설치 진행 여부를 사용자에게 안내한다.
if ! command -v fzf >/dev/null 2>&1; then
  echo "메뉴 선택 도구 fzf가 설치되어 있지 않아 설치합니다. 잠시 기다려 주세요..."
  sudo apt-get update -qq >/dev/null 2>&1
  sudo apt-get install -y -qq fzf >/dev/null 2>&1
  command -v fzf >/dev/null 2>&1 || { echo "fzf 설치에 실패했습니다. 수동으로 설치한 뒤 다시 실행하세요."; exit 1; }
  echo "fzf 설치를 완료했습니다."
fi

# 배포된 ollama 서비스를 자동 발견하고, 각 서비스의 /api/tags 로 '실제 로드된 모델 태그'를 읽는다.
# (하드코딩 카탈로그 없음. 모델을 배포하거나 교체하면 자동으로 반영된다. DEPLOYED 형식 "모델태그|서비스|모델태그")
SVCS="$(kubectl get svc -o name 2>/dev/null | sed 's#.*/##' | grep '^ollama-' | tr '\n' ' ')"
[ -z "$SVCS" ] && { echo "배포된 ollama 모델 서비스가 없습니다. 먼저 bash 7.5.2/install_sllm_models.sh 로 모델을 배포한 뒤 다시 실행하세요."; exit 1; }
# 일회용 curl 파드 1개로 전 서비스의 /api/tags 조회. (sleep 2 = kubectl run -i attach 레이스로 첫 줄 유실 방지)
DEPLOYED="$(kubectl run "disc-$$-$RANDOM" --rm -i --restart=Never --quiet --image=curlimages/curl --command -- \
  sh -c 'sleep 2; for s in '"$SVCS"'; do t=$(curl -s --max-time 15 "http://$s:11434/api/tags" | grep -o "\"name\":\"[^\"]*\"" | head -1 | sed "s/.*:\"//;s/\"//"); [ -n "$t" ] && printf "%s|%s|%s\n" "$t" "$s" "$t"; done' </dev/null 2>/dev/null)"
[ -z "$DEPLOYED" ] && { echo "ollama 서비스에서 모델 정보를 읽지 못했습니다. 잠시 후 다시 실행하세요."; exit 1; }
# 모델 순서를 고정한다: 배포/발견 순서와 무관하게 항상 오름차순으로 정렬(선택 목록·1단계 출력 공통).
DEPLOYED="$(printf '%s\n' "$DEPLOYED" | sort)"
# 1단계 제안자 = 정제 전용(ollama-agg-*) 서비스를 제외한 모델들. 정제 선택지에는 전체가 오른다.
PROPOSERS="$(printf '%s\n' "$DEPLOYED" | awk -F'|' '$2 !~ /^ollama-agg-/')"
[ -z "$PROPOSERS" ] && { echo "제안자 모델이 없습니다. 먼저 bash 7.5.2/install_sllm_models.sh 로 기본 모델을 배포하세요."; exit 1; }

# 1) 정제 모델 선택 (배포된 모델 중 fzf 로)
AGG_NAME="$(printf '%s\n' "$DEPLOYED" | cut -d'|' -f1 | fzf --height=40% --reverse --prompt='정제 모델 선택> ')"
[ -z "$AGG_NAME" ] && { echo "정제 모델을 선택하지 않아 종료합니다."; exit 0; }
AGG_SVC="$(awk -F'|' -v n="$AGG_NAME" '$1==n{print $2; exit}' <<<"$DEPLOYED")"
AGG_MODEL="$(awk -F'|' -v n="$AGG_NAME" '$1==n{print $3; exit}' <<<"$DEPLOYED")"

# 2) 질문 선택 (프리셋) 또는 직접 입력
PROMPTS='What is Kubernetes? Answer in 3 sentences.
What are the differences between Docker and Kubernetes? Answer in 2 sentences.
쿠버네티스란 무엇인가요? 3문장으로 답해주세요.
Docker와 Kubernetes의 차이점은 무엇인가요? 2문장으로 답해주세요.
Other (직접 입력)'
QUESTION="$(printf '%s\n' "$PROMPTS" | fzf --height=40% --reverse --prompt='질문 선택> ')"
[ -z "$QUESTION" ] && { echo "질문을 선택하지 않아 종료합니다."; exit 0; }
case "$QUESTION" in
  'Other (직접 입력)') printf '질문 입력> '; IFS= read -r QUESTION ;;
esac
[ -z "$QUESTION" ] && { echo "직접 입력한 질문이 비어 있어 종료합니다."; exit 1; }

echo ""
echo "정제 모델: $AGG_MODEL"
echo "질문: $QUESTION"

# --- 공용 헬퍼 ---
# JSON 문자열 이스케이프 (역슬래시/따옴표/개행 처리)
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' '; }

# 단일 모델 질의: $1 서비스  $2 모델태그  $3 원문 질문 (ClusterIP -> 일회용 curl 파드).
# 출력 1행 = 추론 시간(초, ollama total_duration), 2행~ = 답변.
ask_one() {
  local think="" content payload raw durns
  case "$2" in qwen*|gemma4*) think='"think":false,' ;; esac   # 추론 모델(qwen/gemma4)은 think=false 로 추론 노출 방지
  content="$(json_escape "$3")"
  payload="{\"model\":\"$2\",${think}\"messages\":[{\"role\":\"user\",\"content\":\"$content\"}],\"stream\":false}"
  raw="$(kubectl run "moa-$$-$RANDOM" --rm -i --restart=Never --quiet --image=curlimages/curl --command -- \
    curl -s "http://$1:11434/api/chat" -d "$payload" </dev/null 2>/dev/null)"
  durns="$(printf '%s' "$raw" | grep -o '"total_duration":[0-9]*' | head -1 | sed 's/.*://')"
  awk -v n="${durns:-0}" 'BEGIN{printf "%.1f\n", n/1e9}'
  printf '%s' "$raw" | sed 's/.*"content":"//;s/"\},"done.*//' | sed 's/\\n/\n/g'
}

# 3) 단계 1 - 제안자 모델들에 동일 질문 (정제 전용 ollama-agg-* 제외)
echo ""
echo "================= 단계 1: 개별 모델 응답 ================="
ANSWERS=""
while IFS='|' read -r name svc tag; do
  [ -z "$name" ] && continue
  echo ""
  echo "모델: $name"
  out="$(ask_one "$svc" "$tag" "$QUESTION")"
  dur="$(printf '%s\n' "$out" | head -1)"
  ans="$(printf '%s\n' "$out" | tail -n +2)"
  echo "답변 (${dur}s):"
  echo "$ans"
  ANSWERS="${ANSWERS}Answer ($name): ${ans} "
done <<EOF
$PROPOSERS
EOF

# 4) 단계 2 - 정제 모델이 답변 정제
echo ""
echo "========== 단계 2: 에이전트 혼합 기법 적용 (정제 모델: $AGG_MODEL) =========="
AGG_PROMPT="You are an expert aggregator. Several AI models answered the question: ${QUESTION} ${ANSWERS}Synthesize the best parts of all answers into one clear, accurate answer, following the length and language requested in the question. Remove any incorrect information."
echo ""
out="$(ask_one "$AGG_SVC" "$AGG_MODEL" "$AGG_PROMPT")"
dur="$(printf '%s\n' "$out" | head -1)"
ans="$(printf '%s\n' "$out" | tail -n +2)"
echo "답변 (${dur}s):"
echo "$ans"
