#!/usr/bin/env bash
# fetch-temp.sh — fetch a wad zip and extract its .wad files into the temporal map dir.
# Usage: bash fetch-temp.sh <doom1|doom2> <path-to-zip>
#   doom1 -> map/doom1-tmp/   doom2 -> map/doom2-tmp/   (game-split temporal wads)
# Temporal wads: disposable test maps for the launcher map menu (-file load).
# They are meant to be deleted: rm map/{doom1,doom2}-tmp/*.wad clears them.
# Contract: one task per script; args in, keyed result lines out; diagnostics to stderr; non-zero on failure.

set -uo pipefail

Scripts="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$Scripts/../../.." && pwd)"

Game="${1:-}"
ZipPath="${2:-}"
case "$Game" in
    doom1|doom2) ;;
    *) echo "usage: fetch-temp.sh <doom1|doom2> <path-to-zip>" >&2; exit 1 ;;
esac

Temp="$Root/map/${Game}-tmp"
if [ -z "$ZipPath" ]; then
    echo "usage: fetch-temp.sh <doom1|doom2> <path-to-zip>" >&2
    echo "  path like: levels/doom2/a-c/aaar20.zip" >&2
    exit 1
fi

mkdir -p "$Temp" || exit 1

Staging="$(mktemp -d)"
trap 'rm -rf "$Staging"' EXIT

Keyed="$(bash "$Scripts/fetch-wad.sh" "$ZipPath" "$Staging")" || {
    echo "fetch-temp-error: fetch-wad.sh failed for $ZipPath" >&2
    exit 1
}

Zip="$(echo "$Keyed" | rg '^WAD=' | cut -d= -f2)"
[ -n "$Zip" ] || {
    echo "fetch-temp-error: no WAD= line from fetch-wad.sh" >&2
    exit 1
}

Out="$(bash "$Scripts/extract-wads.sh" "$Zip" "$Temp")" || {
    echo "fetch-temp-error: extraction failed for $ZipPath" >&2
    exit 1
}

echo "TEMP_DIR=$Temp"
echo "$Out"
exit 0
