#!/usr/bin/env bash
# fetch-download.sh — shared codex wrapper: download a file via the SHARED browser
# Usage: bash fetch-download.sh {url} [timeout-seconds] [--out {dir}] [--selector {css}]
# The wrapper instantiated projects invoke to operate codex's fetch code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/fetch-download.sh. Works from any dive directory;
# the SAVEDPATH= result line passes through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical fetch code
exec bash "$CODEX/_templates/instantiator/fetch-download.sh" "$@"
