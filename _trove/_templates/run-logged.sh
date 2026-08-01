#!/usr/bin/env bash
# run-logged.sh — run a command and record its output with the command line
# Usage: bash run-logged.sh {name} -- {command} [args...]
# Writes {timestamp}-{name}.log into _bitacora/task-stdout/ with a # CMD: header
# showing the exact command; output streams live to the terminal and the file.
set -uo pipefail

NAME="${1:?name required}"
shift
if [ "${1:-}" = "--" ]; then shift; fi
if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

STDOUT_DIR="$(cd "$(dirname "$0")/../_bitacora/task-stdout" && pwd)"
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
