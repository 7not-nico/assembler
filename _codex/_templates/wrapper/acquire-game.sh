#!/usr/bin/env bash
# acquire-game.sh — shared codex wrapper: acquire a game archive through codex's instantiator
# Usage: bash acquire-game.sh {archive} {target-dir}
# The wrapper instantiated projects invoke to operate codex's acquire code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/acquire-game.sh. Works from any dive directory;
# result lines (IMAGE=, SIZE=, STATUS=) pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical acquire code
exec bash "$CODEX/_templates/instantiator/acquire-game.sh" "$@"
