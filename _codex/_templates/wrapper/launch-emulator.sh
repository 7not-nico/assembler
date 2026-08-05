#!/usr/bin/env bash
# launch-emulator.sh — shared codex wrapper: detach-launch an emulator and health-check
# Usage: bash launch-emulator.sh {binary} {rom} [--log {path}] [--env KEY=VALUE...]
# The wrapper instantiated projects invoke to operate codex's launch code.
# Resolves _codex from this wrapper's own location, then delegates to
# _templates/instantiator/launch-emulator.sh. Works from any dive directory;
# the LAUNCH=/ RUN=pid=... result lines pass through unchanged.
set -uo pipefail

CODEX="$(cd "$(dirname "$0")/../.." && pwd)"

# work — one task only: delegate to codex's canonical launch code
exec bash "$CODEX/_templates/instantiator/launch-emulator.sh" "$@"
