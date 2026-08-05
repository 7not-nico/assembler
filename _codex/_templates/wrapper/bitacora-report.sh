#!/usr/bin/env bash
# bitacora-report.sh — shared codex wrapper: create a task-report record
# Usage: bash bitacora-report.sh {topic} ["{project-desc}"]
# The wrapper projects invoke to close a bitacora record. Resolves _codex
# from this wrapper's own location, then delegates to
# _templates/shell/bitacora-report.sh. Works from any dive directory; the
# REPORT= result line passes through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical report shell
exec bash "$CODEX/_templates/shell/bitacora-report.sh" "$@"
