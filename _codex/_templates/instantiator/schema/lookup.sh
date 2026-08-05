#!/usr/bin/env bash
# shell/schema/lookup.sh — cite the schema: export shell_values as env vars
# Sourced by .sh tools (the ONLY way a tool gets a hardcoded value). Reads
# shell/schema/seed.sql and exports each key as SCHEMA_{KEY}={value} —
# e.g. CONSOLE_VALID → SCHEMA_CONSOLE_VALID. Pure: exports constants only.
set -uo pipefail

SCHEMA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA_SEED="$SCHEMA_DIR/seed.sql"

# parse INSERT OR IGNORE rows: ('KEY', 'value', 'desc') — export SCHEMA_KEY
while IFS= read -r line; do
  case "$line" in
  *"'"*)
    key="$(printf '%s' "$line" | sed -n "s/^[[:space:]]*('\([^']*\)'.*/\1/p")"
    val="$(printf '%s' "$line" | sed -n "s/^[[:space:]]*('[^']*', '\([^']*\)'.*/\1/p")"
    [ -n "$key" ] && export "SCHEMA_$key=$val"
    ;;
  esac
done < "$SCHEMA_SEED"
