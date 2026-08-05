#!/usr/bin/env bash
# run-logged.sh — run a command and record its output with the command line
# Usage: bash run-logged.sh {name} -- {command} [args...]
# Writes {timestamp}-{name}.log into _codex/_bitacora/task-stdout/ with a
# # CMD: header showing the exact command; output streams live to the
# terminal and the file. Location-aware: resolves the _codex root whether
# the script lives at _templates/ or _templates/shell/. Log framing lives
# in deps/logger.sh.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/deps/logger.sh"

NAME="${1:?name required}"
shift
if [ "${1:-}" = "--" ]; then shift; fi
if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

log_open "$NAME" "$@"

"$@" 2>&1 | tee -a "$LOG"
log_close "${PIPESTATUS[0]}"
