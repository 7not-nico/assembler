#!/usr/bin/env bash
# trace-evidence.sh — instantiator code: mine evidence lines from an exec trace
# Usage: bash trace-evidence.sh {trace-file} [--patterns {file}] [--head {n}]
# Shared code instantiated projects use to extract evidence from a boot or
# exec trace: matches each regex pattern (defaults cover boot markers, hash
# replacement IDs, SDK runtime entries, and stdout carries; --patterns loads
# an override file, one regex per line) and emits a deduplicated EVIDENCE=
# line per hit with context. Also prints the trace head (--head 20 default)
# and the line count. Result lines: LINES=, EVIDENCE=, TRACE=.
set -uo pipefail

# shell/schema — the only home for hardcoded values; cite it, never hardcode
. "$(cd "$(dirname "$0")" && pwd)/schema/lookup.sh"

TRACE="${1:?trace file required}"
shift
PATFILE=""
HEADN="$SCHEMA_TRACE_HEAD"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --patterns) PATFILE="${2:-}"; shift 2 ;;
    --head) HEADN="${2:-}"; shift 2 ;;
    *) shift ;;
  esac
done

[ -f "$TRACE" ] || { echo "ERROR no such trace: $TRACE" >&2; exit 1; }

DEFAULTS=(
  'Booted'
  'Loading disc'
  'NP[A-Z0-9]{4}[0-9]{5}'
  'memcpy_jak|memmove_jak|memset_jak'
  'stdout:'
  'ATRAC3|MpegAtrac'
  'PPGe|GeInit'
  'GBA DMA'
  'GBA BIOS'
  'GBA Serial I/O'
  'SDL Events'
)

if [ -n "$PATFILE" ]; then
  mapfile -t PATS < "$PATFILE"
else
  PATS=("${DEFAULTS[@]}")
fi

TOTAL="$(wc -l < "$TRACE")"
echo "TRACE=$TRACE"
echo "LINES=$TOTAL"

[ "$HEADN" -gt 0 ] && head -n "$HEADN" "$TRACE" | sed 's/^/HEAD /'

for pat in "${PATS[@]}"; do
  while IFS= read -r line; do
    echo "EVIDENCE $line"
  done < <(grep -En "$pat" "$TRACE" | head -5)
done

echo "DONE $TOTAL lines, ${#PATS[@]} patterns"
