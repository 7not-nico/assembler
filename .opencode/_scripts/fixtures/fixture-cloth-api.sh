#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _sandbox/cloth-config
# ring: 2 (LOCAL-READ) — probes local cloth-config repo structure
# fixture-cloth-api.sh — probes the cloth-config ConfigEntryBuilder API surface
# Shape: KEY=value contract; code-level metrics on the builder→entry factory
# layer. Counts builder-returning methods, loader entry points, and builder
# types. Graceful SKIP when the gitignored _sandbox/ clone is absent.
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"           # repo root
CLONE="$ROOT/_sandbox/cloth-config"

if [[ ! -d "$CLONE" ]]; then
  echo "CLOTH_CONFIG=absent"
  echo "RESULT=skip:none"
  exit 0
fi

SRC="$CLONE/common/src/main/java"
CLOTH="$SRC/me/shedaniel/clothconfig2"
BUILDER="$CLOTH/api/ConfigEntryBuilder.java"

# --- pure probes (reads only) ---

factory_methods="$(rg -c '^\s+(default|static) .*\(' "$BUILDER" 2>/dev/null)"
start_methods="$(rg -c '^\s+(default|static) .* start[A-Z]' "$BUILDER" 2>/dev/null)"
builder_types="$(ls "$CLOTH/impl/builders"/*Builder.java 2>/dev/null | wc -l)"
list_entry_subs="$(ls "$CLOTH/gui/entries"/*ListEntry.java 2>/dev/null | wc -l)"
impl_abstract="$(rg -l '^public abstract class ' "$CLOTH/impl" 2>/dev/null | wc -l)"
forge_loaders="$(find "$CLONE/forge" -name 'ClothConfig*.java' 2>/dev/null | wc -l)"

# start* methods outnumber plain factory methods → builder factory is the core
start_ratio="$(awk -v s="$start_methods" -v f="$factory_methods" \
  'BEGIN { printf "%.2f", (f > 0 ? s / f : 0) }')"

# --- report ---

echo "FACTORY_METHODS=$factory_methods"
echo "START_METHODS=$start_methods"
echo "START_RATIO=$start_ratio"
echo "BUILDER_TYPES=$builder_types"
echo "LIST_ENTRY_SUBS=$list_entry_subs"
echo "IMPL_ABSTRACT=$impl_abstract"
echo "FORGE_LOADERS=$forge_loaders"

ok=1
[[ "$factory_methods" -gt 15 ]] || ok=0
[[ "$start_methods" -gt 13 ]] || ok=0
[[ "$builder_types" -gt 15 ]] || ok=0
[[ "$list_entry_subs" -ge 5 ]] || ok=0
[[ "$forge_loaders" -ge 1 ]] || ok=0

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$factory_methods"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
