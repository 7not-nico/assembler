#!/usr/bin/env bash
# copy-templates.sh — shared codex wrapper: copy template structure into a target dir
# Usage: bash copy-templates.sh {target-dir}
# The wrapper instantiated projects invoke to operate codex's shell tooling.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/shell/copy-templates.sh. Works from any dive directory; the
# COPY lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical copy shell
exec bash "$CODEX/_templates/shell/copy-templates.sh" "$@"
