#!/usr/bin/env bash
# run-logged.sh — run a command and record its output with the command line
# Usage: bash run-logged.sh {name} -- {command} [args...]
# Writes {timestamp}-{name}.log into _knowledge/_bitacora/task-stdout/ with a
# # CMD: header showing the exact command; output streams live to the
# terminal and the file. Location-aware: resolves the _knowledge root from the
# script location, so it works from any _knowledge/{project}/script/.
set -uo pipefail

NAME="${1:?name required}"
shift
if [ "${1:-}" = "--" ]; then shift; fi
if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
case "$SCRIPT_DIR" in
  */_knowledge/*/script) KNOWLEDGE="$(cd "$SCRIPT_DIR/../.." && pwd)" ;;
  *) echo "ERROR run-logged.sh must live under _knowledge/{project}/script" >&2; exit 1 ;;
esac

STDOUT_DIR="$KNOWLEDGE/_bitacora/task-stdout"
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
