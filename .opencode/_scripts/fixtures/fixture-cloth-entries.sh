#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _sandbox/cloth-config
# ring: 2 (LOCAL-READ) — probes local cloth-config repo structure
# fixture-cloth-entries.sh — probes the cloth-config GUI entry layer
# Shape: KEY=value contract; metrics on gui/entries (the rendered config
# rows): concrete vs abstract entry classes, list-entry subtypes, slider
# variants. Graceful SKIP when _sandbox/ absent.
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"           # repo root
CLONE="$ROOT/_sandbox/cloth-config"

if [[ ! -d "$CLONE" ]]; then
  echo "CLOTH_CONFIG=absent"
  echo "RESULT=skip:none"
  exit 0
fi

ENT="$CLONE/common/src/main/java/me/shedaniel/clothconfig2/gui/entries"

# --- pure probes ---
entry_files="$(find "$ENT" -name '*.java' | wc -l)"
entry_abstract="$(rg -l '^public abstract class ' "$ENT" 2>/dev/null | wc -l)"
entry_concrete="$(rg -l '^public class ' "$ENT" 2>/dev/null | wc -l)"
list_entries="$(find "$ENT" -name '*ListEntry.java' | wc -l)"
sliders="$(find "$ENT" -name '*Slider*.java' | wc -l)"
dropdowns="$(find "$ENT" -name '*Dropdown*' -o -name '*Selection*' | wc -l)"

# --- report ---
echo "ENTRY_FILES=$entry_files"
echo "ENTRY_ABSTRACT=$entry_abstract"
echo "ENTRY_CONCRETE=$entry_concrete"
echo "ENTRY_LIST_SUBS=$list_entries"
echo "ENTRY_SLIDERS=$sliders"
echo "ENTRY_SELECTIONS=$dropdowns"

ok=1
[[ "$entry_files" -ge 25 ]] || ok=0
[[ "$entry_concrete" -ge 15 ]] || ok=0
[[ "$list_entries" -ge 5 ]] || ok=0

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$entry_files"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
