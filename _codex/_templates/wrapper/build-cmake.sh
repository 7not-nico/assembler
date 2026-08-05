#!/usr/bin/env bash
# build-cmake.sh — shared codex wrapper: build a cmake tree and verify the binary
# Usage: bash build-cmake.sh {build-dir} [--timeout {seconds}] [--binary {relpath}] [--log {name}]
# The wrapper instantiated projects invoke to operate codex's build code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/build-cmake.sh. Works from any dive directory;
# the BUILD=pass/ BINARY=/ SIZE= result lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical build code
exec bash "$CODEX/_templates/instantiator/build-cmake.sh" "$@"
