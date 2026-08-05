#!/usr/bin/env bash
# bitacora-report.sh — create a task-report record at completion
# Usage: bash bitacora-report.sh {topic} ["{project-desc}"]
# Writes {YYYYMMDD}-{HHMMSS}-{topic}.md into _codex/_bitacora/task-report/
# with the # close-out title and the standard sections: What happened,
# Decisions, Verification, Open edges, Todo state. Refuses to fork an
# existing topic (no-clobber via deps/record.sh). Location-aware: resolves
# the _codex root via deps (walk-up, canonical + dive copies).
# Result line: REPORT={path}. Atomic contract: one task, non-zero on failure.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=deps/record.sh
. "$SCRIPT_DIR/deps/record.sh"

TOPIC="${1:?topic required}"
PROJECT_DESC="${2:-$TOPIC}"

# work — one task only: open + write the report record
record_open task-report "$TOPIC" || exit $?

{
  echo "# $(basename "$RECORD" .md) — $TOPIC close-out"
  echo
  echo "**Date:** $(date +%Y-%m-%d)"
  echo "**Project:** $PROJECT_DESC"
  echo
  echo "## What happened"
  echo
  echo "## Decisions"
  echo
  echo "## Verification"
  echo
  echo "## Open edges"
  echo
  echo "## Todo state"
  echo
} > "$RECORD"

echo "REPORT=$RECORD"
