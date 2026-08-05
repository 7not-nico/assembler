#!/usr/bin/env bash
# bitacora-todo.sh — create a task-todo record for a session/task
# Usage: bash bitacora-todo.sh {topic} ["{project-desc}"]
# Writes {YYYYMMDD}-{HHMMSS}-{topic}.md into _codex/_bitacora/task-todo/
# with the # title, **Date:**, **Project:**, and ## Tasks sections. Refuses
# to fork an existing topic (no-clobber via deps/record.sh). Location-aware:
# resolves the _codex root via deps (walk-up, canonical + dive copies).
# Result line: TODO={path}. Atomic contract: one task, non-zero on failure.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=deps/record.sh
. "$SCRIPT_DIR/deps/record.sh"

TOPIC="${1:?topic required}"

# work — one task only: open + write the todo record
record_open task-todo "$TOPIC" || exit $?

{ printf '# %s — todo\n\n**Date:** %s\n**Project:** %s\n\n## Tasks\n\n' \
    "$TOPIC" "$(date +%Y-%m-%d)" "${2:-$TOPIC}"; } > "$RECORD"

echo "TODO=$RECORD"
