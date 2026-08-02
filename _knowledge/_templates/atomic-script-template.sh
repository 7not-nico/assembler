#!/usr/bin/env bash
# {action}-{subject}.sh — ONE task, line-protocol out, non-zero on failure
# Usage: bash {action}-{subject}.sh {arg} [--timeout {seconds}]
# Atomic unit contract (pattern/atomic-composition):
#   - one responsibility per script
#   - args in, keyed result line out (KEY=value), stderr diagnostics
#   - non-zero exit on any failure
#   - never launches its own browser / daemon — connect to the shared ones
set -uo pipefail

ARG="${1:?arg required}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PORT="${CDP_PORT:-9222}"

# guard: shared resources must exist before work
if ! curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
  echo "ERROR shared browser not running — start it: bash ../../_templates/start-browser.sh" >&2
  exit 1
fi

# work — one task only
# ...

# result line — consumed by the orchestrator
echo "KEY=value"
