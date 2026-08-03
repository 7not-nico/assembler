#!/usr/bin/env bash
# bitacora-find.sh — locate bitacora records by topic with status
# Adapted from .opencode/_bitacora/bitacora-find.sh (knowledge-side copy)
# Usage: bash bitacora-find.sh {topic-regex}
# Searches record names and contents across todo/report/stdout folders;
# prints {kind}/{filename} [status] per match.
set -uo pipefail

TOPIC="${1:?topic regex required}"
BITACORA="$(cd "$(dirname "$0")" && pwd)"
FOLDERS=(task-todo task-report task-stdout)

for folder in "${FOLDERS[@]}"; do
  [ -d "$BITACORA/$folder" ] || continue
  for f in "$BITACORA/$folder"/*; do
    [ -f "$f" ] || continue
    if basename "$f" | rg -qi "$TOPIC" || rg -qi "$TOPIC" "$f" 2>/dev/null; then
      status=""
      case "$folder" in
        task-todo) status=$(rg -m1 "^Status:" "$f" 2>/dev/null | sed 's/^Status: *//') ;;
        task-report) status=$(rg -m1 "^Timestamp:" "$f" 2>/dev/null | sed 's/^Timestamp: *//') ;;
      esac
      printf "%-14s %s%s\n" "$folder" "$(basename "$f")" "${status:+  [${status}]}"
    fi
  done
done
