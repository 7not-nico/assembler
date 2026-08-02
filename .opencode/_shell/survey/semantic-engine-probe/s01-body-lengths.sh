#!/usr/bin/env bash
# s01-body-lengths.sh — measure per-table body text length stats from patlib.db
# Mirrors semantic-eval loadDocuments: content columns = non-meta columns, each capped at 2000 chars.
# Usage: bash s01-body-lengths.sh [TABLE]
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
DB="${1:-$ROOT/.opencode/patlib.db}"
META="id source tags status reference type created modified enforcement priority"
INTERNAL="embeddings fts_entities entities_fts meta notes sqlite_sequence"

tables=$(sqlite3 "$DB" "SELECT name FROM sqlite_master WHERE type='table' AND sql LIKE '%id TEXT%' AND sql LIKE '%title TEXT%' AND name NOT IN ($(echo $INTERNAL | sed "s/ /','/g; s/^/'/; s/$/'/")) ORDER BY name")

if [ -n "${1:-}" ]; then
  tables=$(echo "$tables" | rg -x "$1" || true)
fi

echo "TABLE                 ROWS     AVG_BODY  MAX_BODY"
echo "-----------------------------------------------"
total_rows=0
total_max=0
for t in $tables; do
  cols=$(sqlite3 "$DB" "PRAGMA table_info(\"$t\")" | cut -d'|' -f2)
  expr=""
  for c in $cols; do
    case " $META " in *" $c "*) continue ;; esac
    expr="${expr} + min(length(coalesce(\"$c\",'')),2000)"
  done
  expr="${expr# + }"
  if [ -z "$expr" ]; then continue; fi
  IFS='|' read -r rows avg max < <(sqlite3 "$DB" "SELECT COUNT(*), CAST(COALESCE(ROUND(AVG(blen)),0) AS INT), COALESCE(MAX(blen),0) FROM (SELECT ${expr} AS blen FROM \"$t\")")
  printf "%-20s %7s %10s %9s\n" "$t" "$rows" "$avg" "$max"
  total_rows=$((total_rows + rows))
  if [ "${max:-0}" -gt "$total_max" ]; then total_max=$max; fi
done
echo "-----------------------------------------------"
echo "TABLE_COUNT=$(echo "$tables" | rg -c . || echo 0)"
echo "TOTAL_ROWS=$total_rows"
echo "GLOBAL_MAX_BODY=$total_max"
