#!/usr/bin/env bash
shopt -s nullglob

echo "🧹 [7.5] 소형 LLM(sLLM) 실습 리소스 정리"

CH7="$HOME/_Book_k8sInfra/ch7"

# 7.5.2 기본 sLLM 모델(젬마 / 라마 / 큐원) 디플로이먼트 및 서비스 삭제
for yaml_file in "$CH7"/7.5.2/models/base/*-ollama.yaml; do
  kubectl delete -f "$yaml_file" 2>/dev/null
done

# 7.5.3 정제(aggregator) 전용 모델(w4-k8s의 ollama-agg-*)을 배포했다면 함께 삭제
for yaml_file in "$CH7"/7.5.3/models/*-ollama.yaml; do
  kubectl delete -f "$yaml_file" 2>/dev/null
done

echo "✅ 7.5 cleanup done."
