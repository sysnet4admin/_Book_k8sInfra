#!/usr/bin/env bash
# 7.5.2 - 대화형 단일 소형 LLM 질의: 모델 선택(fzf) -> 프롬프트 선택/입력(fzf) -> 결과 출력
set -uo pipefail

echo "소형 LLM 질문 대화형 콘솔"
echo "================================================"
echo "배포된 소형 LLM 하나를 골라 질문을 보내고 응답을 확인합니다."

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
# 모델 순서를 고정한다: 배포/발견 순서와 무관하게 항상 오름차순으로 정렬.
DEPLOYED="$(printf '%s\n' "$DEPLOYED" | sort)"

# 질문 템플릿 (마지막은 직접 입력)
PROMPTS='What is Kubernetes? Answer in 3 sentences.
What are the differences between Docker and Kubernetes? Answer in 2 sentences.
쿠버네티스란 무엇인가요? 3문장으로 답해주세요.
Docker와 Kubernetes의 차이점은 무엇인가요? 2문장으로 답해주세요.
Other (직접 입력)'

# 1) 모델 선택 - 배포된 모델만 fzf 에 표시명(1열)으로, 선택값으로 서비스/태그 역참조
NAME="$(printf '%s\n' "$DEPLOYED" | cut -d'|' -f1 | fzf --height=40% --reverse --prompt='모델 선택> ')"
[ -z "$NAME" ] && { echo "모델을 선택하지 않아 종료합니다."; exit 0; }
SVC="$(awk -F'|' -v n="$NAME" '$1==n{print $2; exit}' <<<"$DEPLOYED")"
MODEL="$(awk -F'|' -v n="$NAME" '$1==n{print $3; exit}' <<<"$DEPLOYED")"

# 2) 질문 선택 또는 직접 입력
PROMPT="$(printf '%s\n' "$PROMPTS" | fzf --height=40% --reverse --prompt='질문 선택> ')"
[ -z "$PROMPT" ] && { echo "질문을 선택하지 않아 종료합니다."; exit 0; }
case "$PROMPT" in
  'Other (직접 입력)') printf '질문 입력> '; IFS= read -r PROMPT ;;
esac
[ -z "$PROMPT" ] && { echo "직접 입력한 질문이 비어 있어 종료합니다."; exit 1; }

# 3) JSON 페이로드 (추론 모델 qwen/gemma4 는 think=false 로 추론 노출 방지; 질문은 JSON 이스케이프)
THINK=""; case "$MODEL" in qwen*|gemma4*) THINK='"think":false,' ;; esac
CONTENT="$(printf '%s' "$PROMPT" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')"
PAYLOAD="{\"model\":\"$MODEL\",${THINK}\"messages\":[{\"role\":\"user\",\"content\":\"$CONTENT\"}],\"stream\":false}"

echo ""
echo "모델: $MODEL"
echo "질문: $PROMPT"
echo ""

# 4) ClusterIP 서비스에 질의 - 일회용 curl 파드로 호출 후 자동 정리
RAW="$(kubectl run "sllm-query-$$-$RANDOM" --rm -i --restart=Never --quiet --image=curlimages/curl --command -- \
  curl -s "http://$SVC:11434/api/chat" -d "$PAYLOAD" </dev/null 2>/dev/null)"
ANS="$(printf '%s' "$RAW" | sed 's/.*"content":"//;s/"\},"done.*//' | sed 's/\\n/\n/g')"
# ollama 가 응답에 보고한 추론 시간(total_duration, 나노초) -> 초. 파드/네트워크 오버헤드 제외.
DUR_NS="$(printf '%s' "$RAW" | grep -o '"total_duration":[0-9]*' | head -1 | sed 's/.*://')"
echo "답변 ($(awk -v n="${DUR_NS:-0}" 'BEGIN{printf "%.1f", n/1e9}')s):"
echo "$ANS"
