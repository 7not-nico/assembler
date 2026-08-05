#!/usr/bin/env bash
# bitacora-run.sh — run a command and record its output with the codex bitacora
# Usage: bash bitacora-run.sh {name} [--trace] -- {command} [args...]
# Writes {timestamp}-{name}.log into _codex/_bitacora/task-stdout/ with a
# # CMD: header showing the exact command, # DATE:, # CWD:; the output streams
# live to the terminal and the file. --trace enriches the stream through
# tracexec (exec-tree lines, for boot/launch analysis). The tail appends
# # DUR: (elapsed milliseconds), # DATE: (completion), and # exit: status —
# the same header fields the root assembler bitacora-log.sh records.
# Location-aware: resolves the _codex root whether the script lives at
# _templates/ or _templates/shell/.
set -uo pipefail

NAME="${1:?name required}"
shift
TRACE=""
if [ "${1:-}" = "--trace" ]; then TRACE=1; shift; fi
if [ "${1:-}" = "--" ]; then shift; fi
if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
case "$SCRIPT_DIR" in
  */_templates/shell) CODEX="$(cd "$SCRIPT_DIR/../.." && pwd)" ;;
  */_templates) CODEX="$(cd "$SCRIPT_DIR/.." && pwd)" ;;
  *) echo "ERROR bitacora-run.sh must live under _codex/_templates[/shell]" >&2; exit 1 ;;
esac

STDOUT_DIR="$CODEX/_bitacora/task-stdout"
mkdir -p "$STDOUT_DIR"
LOG="$STDOUT_DIR/$(date +%Y%m%d-%H%M%S)-$NAME.log"
CMD="$(printf '%q ' "$@")"

{
  echo "# CMD: $CMD"
  echo "# DATE: $(date -Is)"
  echo "# CWD: $(pwd)"
  echo "# --------------------"
} | tee "$LOG"

START="$(date +%s%N)"
if [ -n "$TRACE" ]; then
  tracexec log -- "$@" 2>&1 | tee -a "$LOG"
else
  "$@" 2>&1 | tee -a "$LOG"
fi
STATUS="${PIPESTATUS[0]}"
DUR="$(($(($(date +%s%N) - START)) / 1000000))ms"
echo "# DUR: $DUR" | tee -a "$LOG"
echo "# DATE: $(date -Is)" | tee -a "$LOG"
echo "# exit: $STATUS" | tee -a "$LOG"
exit "$STATUS"
