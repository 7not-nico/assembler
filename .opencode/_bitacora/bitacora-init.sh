#!/usr/bin/env bash
# bitacora-init.sh — ensure the .opencode/_bitacora record skeleton exists
# Repurposed from _codex/_templates/shell/copy-templates.sh (structure copy)
# Usage: bash bitacora-init.sh
# Creates the {?}-{concrete noun} record folders + README when missing.
# Location-aware: resolves the .opencode root from _bitacora/ (this dir).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BITACORA="$ROOT/_bitacora"
FOLDERS=(task-audit task-plan task-reference task-report task-survey task-todo task-stdout)

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
# Bitacora — record area

Records follow the `{?}-{concrete noun}` convention. Todo precedes work; report follows completion; both stay open while working.

| Folder | Content |
|--------|---------|
| `task-todo/` | persistent task lists, `{YYYY-MM-DD}--{slug}.md` |
| `task-report/` | factual records, `{YYYYMMDD}-{HHMMSS}-{topic}.md` |
| `task-audit/` | audit logs |
| `task-plan/` | plan documents |
| `task-survey/` | survey records |
| `task-reference/` | query flags, schema details, lookup tables |
| `task-stdout/` | command logs from bitacora-log.sh |
EOF
  echo "CREATE $BITACORA/README.md"
else
  echo "EXISTS $BITACORA/README.md"
fi

echo "DONE   $BITACORA"
