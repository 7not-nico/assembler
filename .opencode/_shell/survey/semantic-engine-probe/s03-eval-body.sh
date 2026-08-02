#!/usr/bin/env bash
# s03-eval-body.sh — bounded semantic-eval --documents body run (concurrency-safe verification)
# Usage: bash s03-eval-body.sh [batch_size] [k]
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
BATCH="${1:-2}"
K="${2:-5}"

echo "STAGE=s03-eval-body BATCH=$BATCH K=$K"
if timeout --signal=KILL 300 bun run "$ROOT/.opencode/tools/semantic-eval.ts" --documents body --batch-size "$BATCH" --k "$K" --variant default; then
  echo "RESULT=pass"
else
  code=$?
  echo "RESULT=fail EXIT=$code"
  exit 1
fi
