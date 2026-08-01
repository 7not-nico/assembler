#!/usr/bin/env bash
# bitacora-log.sh — run a command and record its output in task-stdout
# Repurposed from _codex/_templates/shell/run-logged.sh (identical logic)
# Usage: bash bitacora-log.sh {name} -- {command} [args...]
# Writes {YYYYMMDD}-{HHMMSS}-{name}.log with # CMD:/# DATE:/# CWD: header;
# output streams live and appends # exit: {status}.
set -uo pipefail

NAME="${1:?name required}"
shift
if [ "${1:-}" = "--" ]; then shift; fi
if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

BITACORA="$(cd "$(dirname "$0")" && pwd)"
STDOUT_DIR="$BITACORA/task-stdout"
mkdir -p "$STDOUT_DIR"
LOG="$STDOUT_DIR/$(date +%Y%m%d-%H%M%S)-$NAME.log"
CMD="$(printf '%q ' "$@")"

{
  echo "# CMD: $CMD"
  echo "# DATE: $(date -Is)"
  echo "# CWD: $(pwd)"
  echo "# --------------------"
} | tee "$LOG"

"$@" 2>&1 | tee -a "$LOG"
STATUS="${PIPESTATUS[0]}"
echo "# exit: $STATUS" | tee -a "$LOG"
exit "$STATUS"
