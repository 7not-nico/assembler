#!/usr/bin/env bash
# deps/logger.sh — shared shell dependency: bitacora log framing
# Sourced by shell loggers (bitacora-run.sh, run-logged.sh). The caller sets
# SCRIPT_DIR before sourcing; log_open resolves CODEX from it (deps/paths.sh),
# creates {timestamp}-{name}.log under _codex/_bitacora/task-stdout/, writes
# the # CMD:/# DATE:/# CWD: header, and sets LOG + START. log_close appends
# # DUR:, # DATE:, # exit: and exits with the command status — the same tail
# fields the root assembler bitacora-log.sh records.
set -uo pipefail

# shellcheck source=paths.sh
. "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

log_open() {
  local name="$1"
  shift
  resolve_codex "$SCRIPT_DIR"
  local stdout_dir="$CODEX/_bitacora/task-stdout"
  mkdir -p "$stdout_dir"
  LOG="$stdout_dir/$(date +%Y%m%d-%H%M%S)-$name.log"
  CMD="$(printf '%q ' "$@")"
  {
    echo "# CMD: $CMD"
    echo "# DATE: $(date -Is)"
    echo "# CWD: $(pwd)"
    echo "# --------------------"
  } | tee "$LOG"
  START="$(date +%s%N)"
}

log_close() {
  local status="$1"
  DUR="$(($(($(date +%s%N) - START)) / 1000000))ms"
  echo "# DUR: $DUR" | tee -a "$LOG"
  echo "# DATE: $(date -Is)" | tee -a "$LOG"
  echo "# exit: $status" | tee -a "$LOG"
  exit "$status"
}
