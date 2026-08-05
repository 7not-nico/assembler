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
# _templates/ or _templates/shell/. Log framing lives in deps/logger.sh.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/deps/logger.sh"

NAME="${1:?name required}"
shift
TRACE=""
[ "${1:-}" = "--trace" ] && { TRACE=1; shift; }
[ "${1:-}" = "--" ] && shift
[ "$#" -gt 0 ] || { echo "command required" >&2; exit 1; }

log_open "$NAME" "$@"
if [ -n "$TRACE" ]; then tracexec log -- "$@" 2>&1 | tee -a "$LOG"; else "$@" 2>&1 | tee -a "$LOG"; fi
log_close "${PIPESTATUS[0]}"
