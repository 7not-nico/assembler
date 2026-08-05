#!/usr/bin/env bash
# copy-skills.sh — shared codex wrapper: copy SKILL.md files into a docs dir, flattened
# Usage: bash copy-skills.sh {dest-docs-dir} {skill-name}...
# The wrapper instantiated projects invoke to operate codex's shell tooling.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/shell/copy-skills.sh. Works from any dive directory; the
# SKILL/MISS lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical copy-skills shell
exec bash "$CODEX/_templates/shell/copy-skills.sh" "$@"
