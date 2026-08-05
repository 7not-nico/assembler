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

# work — one task only: open + write the report record
record_open task-report "$TOPIC" || exit $?

{ printf '# %s — %s close-out\n\n**Date:** %s\n**Project:** %s\n\n## What happened\n\n## Decisions\n\n## Verification\n\n## Open edges\n\n## Todo state\n\n' \
    "$(basename "$RECORD" .md)" "$TOPIC" "$(date +%Y-%m-%d)" "${2:-$TOPIC}"; } > "$RECORD"

echo "REPORT=$RECORD"
