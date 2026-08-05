#!/usr/bin/env bash
# deps/paths.sh — shared instantiator dependency: resolve codex paths
# Sourced by instantiator tools (`. "$(dirname "$0")/deps/paths.sh"`).
# Resolves from this file's own location, so it works from any cwd and any
# instantiator tool. Sets: SHELL_DIR (instantiator/), CODEX (_codex/),
# ASSEMBLER (workspace root). Pure: exports vars only, no side effects.
set -uo pipefail

DEPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_DIR="$(cd "$DEPS_DIR/.." && pwd)"
CODEX="$(cd "$DEPS_DIR/../../.." && pwd)"
ASSEMBLER="$(cd "$DEPS_DIR/../../../.." && pwd)"
