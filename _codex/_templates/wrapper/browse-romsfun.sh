#!/usr/bin/env bash
# browse-romsfun.sh — shared codex wrapper: browse a game's download variants
# Usage: bash browse-romsfun.sh {game-name-or-slug} [--timeout {seconds}] [{console}]
# The wrapper instantiated projects invoke to operate codex's browse code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/browse-romsfun.sh. Works from any dive directory;
# the GAME/ VARIANTS: machine lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical browse code
exec bash "$CODEX/_templates/instantiator/browse-romsfun.sh" "$@"
