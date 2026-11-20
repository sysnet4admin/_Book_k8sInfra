#!/usr/bin/env bash

echo "🧹 [7.1~7.4] sLLM 배포 전 이전 절 실습 리소스 정리"

CH7="$HOME/_Book_k8sInfra/ch7"
bash "$CH7/7.1.3/cleanup_7.1_tasks.sh"
bash "$CH7/7.2.3/cleanup_7.2_tasks.sh"
bash "$CH7/7.3.3/cleanup_7.3_tasks.sh"
bash "$CH7/7.4.3/cleanup_7.4_tasks.sh"

echo "✅ 7.1~7.4 cleanup done."
