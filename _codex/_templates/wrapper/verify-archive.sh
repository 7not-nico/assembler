#!/usr/bin/env bash
# verify-archive.sh — shared codex wrapper: verify a downloaded game archive
# Usage: bash verify-archive.sh {file} [--image-ext {ext,ext...}]
# The wrapper instantiated projects invoke to operate codex's verify code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/verify-archive.sh. Works from any dive directory;
# the OK=/ IMAGE=/ SIZE= result lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical verify code
exec bash "$CODEX/_templates/instantiator/verify-archive.sh" "$@"
