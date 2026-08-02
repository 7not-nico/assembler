#!/usr/bin/env bash
# run-probe.sh — orchestrate the semantic engine probe survey stages
# Survey workflow: .opencode/_shell/survey/semantic-engine-probe/
# Usage: bash run-probe.sh [batch_size]
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "STAGE=s01-body-lengths"
bash "$DIR/s01-body-lengths.sh" || exit 1
echo
echo "STAGE=s02-embed-probe"
bun run "$DIR/s02-embed-probe.ts" || exit 1
echo
echo "STAGE=s03-eval-body"
bash "$DIR/s03-eval-body.sh" "${1:-2}" || exit 1
echo
echo "PROBE=complete"
