#!/usr/bin/env bash
# deps/record.sh — shell dependency: bitacora record lifecycle
# Sourced by record shells (bitacora-todo.sh, bitacora-report.sh). The
# caller sets SCRIPT_DIR before sourcing; record_open resolves CODEX from
# it (deps/paths.sh), creates {timestamp}-{topic}.md under
# _codex/_bitacora/{subdir}/, and refuses to fork an existing topic.
# Sets: RECORD (the file path). Pure: resolution + mkdir + name only.
set -uo pipefail

# shellcheck source=paths.sh
. "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

# record_open {subdir} {topic} — open a record file, no-clobber
# subdir: task-todo | task-report | task-stdout
record_open() {
  local subdir="${1:?subdir required}" topic="${2:?topic required}"
  codex_root "$SCRIPT_DIR"
  local dir="$CODEX/_bitacora/$subdir"
  mkdir -p "$dir"

  # no-clobber: same topic → fail, never fork the record
  if [ -n "$(ls "$dir"/*-"$topic.md" 2>/dev/null | head -1)" ]; then
    echo "ERROR $subdir record exists: $(ls "$dir"/*-"$topic.md" 2>/dev/null | head -1)" >&2
    return 1
  fi

  RECORD="$dir/$(date +%Y%m%d-%H%M%S)-$topic.md"
}
