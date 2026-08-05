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
PROJECT_DESC="${2:-$TOPIC}"

# work — one task only: open + write the todo record
record_open task-todo "$TOPIC" || exit $?

{
  echo "# $TOPIC — todo"
  echo
  echo "**Date:** $(date +%Y-%m-%d)"
  echo "**Project:** $PROJECT_DESC"
  echo
  echo "## Tasks"
  echo
} > "$RECORD"

echo "TODO=$RECORD"
