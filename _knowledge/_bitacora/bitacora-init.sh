#!/usr/bin/env bash
# bitacora-init.sh — ensure the _knowledge/_bitacora record skeleton exists
# Usage: bash bitacora-init.sh
# Creates the core record folders + README when missing.
# Location-aware: resolves _knowledge/_bitacora/ from this script's location.
set -euo pipefail

BITACORA="$(cd "$(dirname "$0")" && pwd)"
FOLDERS=(task-todo task-report task-stdout)

for folder in "${FOLDERS[@]}"; do
  if [ -d "$BITACORA/$folder" ]; then
    echo "EXISTS $BITACORA/$folder"
  else
    mkdir -p "$BITACORA/$folder"
    echo "CREATE $BITACORA/$folder"
  fi
done

if [ ! -f "$BITACORA/README.md" ]; then
  cat > "$BITACORA/README.md" <<'EOF'
# Bitacora — knowledge record area

Records follow the `{?}-{concrete noun}` convention. Todo precedes work; report follows completion; both stay open while working.

| Folder | Content |
|--------|---------|
| `task-todo/` | persistent task lists, `{YYYY-MM-DD}--{slug}.md` |
| `task-report/` | factual records, `{YYYYMMDD}-{HHMMSS}-{topic}.md` |
| `task-stdout/` | command logs from bitacora-log.sh / run-logged.sh |

Subprojects write command logs here through `script/run-logged.sh`; this folder hosts the shared record tooling.
EOF
  echo "CREATE $BITACORA/README.md"
else
  echo "EXISTS $BITACORA/README.md"
fi

echo "DONE   $BITACORA"
