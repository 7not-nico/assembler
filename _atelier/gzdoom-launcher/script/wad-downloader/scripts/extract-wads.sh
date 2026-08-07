#!/usr/bin/env bash
# extract-wads.sh — extract .wad files (any case) from a zip into a target dir.
# Usage: bash extract-wads.sh <zip> <dest-dir>
# Contract: one task per script; args in, keyed result lines out; diagnostics to stderr; non-zero on failure.

set -uo pipefail

Zip="${1:-}"
Dest="${2:-}"

if [ -z "$Zip" ] || [ -z "$Dest" ]; then
    echo "usage: extract-wads.sh <zip> <dest-dir>" >&2
    exit 1
fi
[ -f "$Zip" ] || {
    echo "extract-error: zip missing: $Zip" >&2
    exit 1
}

mkdir -p "$Dest" || exit 1
Work="$(mktemp -d)"
trap 'rm -rf "$Work"' EXIT

7z e -o"$Work" -y "$Zip" > /dev/null 2>&1 || {
    echo "extract-error: 7z extraction failed for $Zip" >&2
    exit 1
}

# .wad entries arrive in any case (e.g. HOOVER.WAD); match case-insensitively
Moved=0
for f in "$Work"/*; do
    [ -f "$f" ] || continue
    case "$(basename "$f")" in
        *.wad|*.WAD|*.Wad) mv "$f" "$Dest/" && Moved=1 ;;
    esac
done
[ "$Moved" = "1" ] || {
    echo "extract-error: no .wad files in $Zip" >&2
    exit 1
}

Count="$(ls "$Dest"/*.wad "$Dest"/*.WAD "$Dest"/*.Wad 2>/dev/null | wc -l)"
echo "EXTRACTED=$Count"
ls "$Dest"/*.wad "$Dest"/*.WAD "$Dest"/*.Wad 2>/dev/null | sort | sed "s/^/WAD=/"
exit 0
