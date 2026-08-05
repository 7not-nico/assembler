#!/usr/bin/env bash
# fetch-repo.sh — shared codex wrapper: shallow-clone a repo into a project dir
# Usage: bash one-off/fetch-repo.sh {repo-url} {base-dir} [fallback-url...]
# One-off bootstrap wrapper (wrapper/one-off/). Resolves _codex from this
# wrapper's own location, then delegates to _templates/shell/fetch-repo.sh.
# Works from any dive directory; the FETCH lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../../.." && pwd)"

# work — one task only: delegate to codex's canonical shell
exec bash "$CODEX/_templates/shell/fetch-repo.sh" "$@"
