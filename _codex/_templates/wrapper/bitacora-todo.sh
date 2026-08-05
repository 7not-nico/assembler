#!/usr/bin/env bash
# bitacora-todo.sh — shared codex wrapper: create a task-todo record
# Usage: bash bitacora-todo.sh {topic} ["{project-desc}"]
# The wrapper projects invoke to open a bitacora todo. Resolves _codex from
# this wrapper's own location, then delegates to
# _templates/shell/bitacora-todo.sh. Works from any dive directory; the
# TODO= result line passes through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical todo shell
exec bash "$CODEX/_templates/shell/bitacora-todo.sh" "$@"
