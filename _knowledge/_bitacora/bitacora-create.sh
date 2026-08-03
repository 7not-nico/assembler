#!/usr/bin/env bash
# bitacora-create.sh — scaffold a new bitacora record with convention naming
# Adapted from .opencode/_bitacora/bitacora-create.sh (knowledge-side copy)
# Usage: bash bitacora-create.sh {kind} {topic}
# Kinds: todo|report  (stdout is a log stream, not a created record)
# Names: todo    → task-todo/{YYYY-MM-DD}--{slug}.md
#        report  → task-report/{YYYYMMDD}-{HHMMSS}-{slug}.md
set -euo pipefail

KIND="${1:?kind required (todo|report)}"
TOPIC="${2:?topic required}"
case "$KIND" in
  todo|report) ;;
  *) echo "ERROR kind must be todo or report" >&2; exit 1 ;;
esac
BITACORA="$(cd "$(dirname "$0")" && pwd)"
FOLDER="task-$KIND"

[ -d "$BITACORA/$FOLDER" ] || bash "$BITACORA/bitacora-init.sh" >/dev/null

SLUG="$(bash "$BITACORA/bitacora-slugify.sh" "$TOPIC")"
STAMP="$(date +%Y%m%d-%H%M%S)"
DATE="$(date +%Y-%m-%d)"

case "$KIND" in
  todo) FILE="$BITACORA/$FOLDER/$DATE--$SLUG.md" ;;
  *)    FILE="$BITACORA/$FOLDER/$STAMP-$SLUG.md" ;;
esac
if [ -e "$FILE" ]; then echo "ERROR exists: $FILE" >&2; exit 1; fi

case "$KIND" in
  todo)
    cat > "$FILE" <<EOF
# $TOPIC

Status: in progress ($DATE)

## Tasks

- [ ] task one
- [ ] task two

## Context

-
EOF
    ;;
  report)
    cat > "$FILE" <<EOF
# $TOPIC

Timestamp: $DATE $STAMP

## What was done

## Decisions

## Open edges

## Todo state

-
EOF
    ;;
esac

echo "CREATE $FILE"
