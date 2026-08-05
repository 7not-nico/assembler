#!/usr/bin/env bash
# trace-evidence.sh — shared codex wrapper: mine evidence lines from an exec trace
# Usage: bash trace-evidence.sh {trace-file} [--patterns {file}] [--head {n}]
# The wrapper instantiated projects invoke to operate codex's trace code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/trace-evidence.sh. Works from any dive directory;
# the LINES=/ EVIDENCE= result lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical trace code
exec bash "$CODEX/_templates/instantiator/trace-evidence.sh" "$@"
