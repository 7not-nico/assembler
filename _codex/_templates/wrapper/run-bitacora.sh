#!/usr/bin/env bash
# run-bitacora.sh — shared codex wrapper: log a command through codex's bitacora
# Usage: bash run-bitacora.sh {name} [--trace] -- {command} [args...]
# The wrapper instantiated projects invoke to operate with codex's shells.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/shell/bitacora-run.sh. --trace passes through to the shell
# (tracexec exec-tree enrichment). Works from any dive directory — the log
# lands in _codex/_bitacora/task-stdout/{timestamp}-{name}.log regardless of
# cwd. Result lines: LOGGED={name}, STATUS={exit}.
set -uo pipefail

NAME="${1:?name required}"
shift
TRACE=""
if [ "${1:-}" = "--trace" ]; then TRACE=1; shift; fi
if [ "${1:-}" = "--" ]; then shift; fi
if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical bitacora shell
if [ -n "$TRACE" ]; then
  bash "$CODEX/_templates/shell/bitacora-run.sh" "$NAME" --trace -- "$@"
else
  bash "$CODEX/_templates/shell/bitacora-run.sh" "$NAME" -- "$@"
fi
STATUS=$?
if [ $STATUS -ne 0 ]; then
  echo "ERROR $NAME failed (exit $STATUS)" >&2
fi

# result lines — consumed by the dive orchestrator
echo "LOGGED=$NAME"
echo "STATUS=$STATUS"
exit "$STATUS"
