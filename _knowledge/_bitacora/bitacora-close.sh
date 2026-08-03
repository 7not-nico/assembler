#!/usr/bin/env bash
# bitacora-close.sh — complete a todo and scaffold its task report
# Adapted from .opencode/_bitacora/bitacora-close.sh (knowledge-side copy)
# Usage: bash bitacora-close.sh {todo-file} {report-topic}
#   todo-file: path or basename inside task-todo/
# Completes all pending items, stamps the Status line, then creates
# the report via bitacora-create.sh. Prints TODO and REPORT paths.
set -euo pipefail

TODO="${1:?todo file required (path or name in task-todo/)}"
TOPIC="${2:?report topic required}"
BITACORA="$(cd "$(dirname "$0")" && pwd)"
TODO_DIR="$BITACORA/task-todo"
DATE="$(date +%Y-%m-%d)"

if [ -f "$TODO" ]; then
  FILE="$TODO"
else
  FILE="$TODO_DIR/$TODO"
fi
[ -f "$FILE" ] || { echo "ERROR todo not found: $TODO" >&2; exit 1; }

sed -i 's/^- \[ \]/- [x]/' "$FILE"
if rg -q "^Status:" "$FILE"; then
  sed -i "s/^Status:.*/Status: completed ($DATE)/" "$FILE"
else
  printf "\nStatus: completed (%s)\n" "$DATE" >> "$FILE"
fi

REPORT="$(bash "$BITACORA/bitacora-create.sh" report "$TOPIC" | sed 's/^CREATE //')"
echo "TODO   $FILE"
echo "REPORT $REPORT"
echo "NEXT   fill the report: what was done, decisions, open edges, todo state; cite task-stdout logs"
