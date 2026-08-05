#!/usr/bin/env bash
# deps/paths.sh — shared shell dependency: location-aware _codex resolution
# Sourced by shell deps (logger.sh) and shell tools. Provides resolve_codex
# {caller-script-dir}: resolves CODEX (_codex/) whether the caller lives at
# _templates/shell/ or _templates/. Pure: exports CODEX only, no side effects.
set -uo pipefail

resolve_codex() {
  case "$1" in
    */_templates/shell) CODEX="$(cd "$1/../.." && pwd)" ;;
    */_templates) CODEX="$(cd "$1/.." && pwd)" ;;
    *) echo "ERROR caller must live under _codex/_templates[/shell]" >&2; exit 1 ;;
  esac
}
