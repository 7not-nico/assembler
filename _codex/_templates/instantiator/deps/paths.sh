#!/usr/bin/env bash
# deps/paths.sh — instantiator dependency: resolve codex paths
# Executes the shared codexroot Go binary at _shared/bin (fixed depth —
# instantiator tools never copy into dives). Sets: DEPS_DIR (instantiator/
# deps), SHARED_BIN (_shared/bin), SHELL_DIR (instantiator/), CODEX
# (_codex/), ASSEMBLER (workspace root). Pure: exports vars only.
set -uo pipefail

DEPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_BIN="$(cd "$DEPS_DIR/../../_shared/bin" && pwd)"
CODEX="$("$SHARED_BIN/codexroot" "$DEPS_DIR")" || exit $?
SHELL_DIR="$(cd "$DEPS_DIR/.." && pwd)"
ASSEMBLER="$(cd "$CODEX/.." && pwd)"
