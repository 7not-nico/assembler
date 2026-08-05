#!/usr/bin/env bash
# scaffold-knowledge.sh — shared codex wrapper: bootstrap a 13-layer knowledge project
# Usage: bash scaffold-knowledge.sh {name} "{domain}" [--with-skills]
# The wrapper instantiated projects invoke to operate codex's shell tooling.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/shell/scaffold-knowledge.sh. Works from any dive directory;
# the output lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical scaffold shell
exec bash "$CODEX/_templates/shell/scaffold-knowledge.sh" "$@"
