#!/usr/bin/env bash
# stop-process.sh — shared codex wrapper: stop a process chain by exact name
# Usage: bash stop-process.sh {binary-name}
# The wrapper instantiated projects invoke to operate codex's stop code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/stop-process.sh. Works from any dive directory;
# result lines (STOPPED=) pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical stop code
exec bash "$CODEX/_templates/instantiator/stop-process.sh" "$@"
