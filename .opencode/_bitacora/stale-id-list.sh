#!/usr/bin/env bash
# stale-id-list.sh — group stale-refs output into per-ID counts
# Usage: bash stale-id-list.sh [--top N]
# Runs `rs check stale-refs`, extracts the stale ID column, prints
# count + ID sorted descending. Default top 25.
set -euo pipefail

TOP="${1:-25}"
if [ "$TOP" = "--top" ]; then
  TOP="${2:?--top requires a number}"
fi
SCRIPTS="$(cd "$(dirname "$0")/../_scripts" && pwd)"

"$SCRIPTS/rs" check stale-refs 2>/dev/null \
  | awk -F'|' '{gsub(/ /,"",$1); if ($1 ~ /^[A-Z]{2,}\./) print $1}' \
  | sort | uniq -c | sort -rn \
  | awk -v top="$TOP" 'NR<=top {printf "%6d  %s\n", $1, $2}'
