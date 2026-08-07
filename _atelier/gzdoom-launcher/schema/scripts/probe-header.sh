#!/usr/bin/env bash
# probe-header.sh — extract the first .wad from a zip and probe its 4-byte header.
# Usage: bash probe-header.sh <zip>
# Contract: one task per script; args in, keyed result line out; diagnostics to stderr; non-zero on failure.

set -uo pipefail

Zip="${1:-}"
[ -f "$Zip" ] || { echo "usage: probe-header.sh <zip>" >&2; exit 1; }

Work="$(mktemp -d)"
trap 'rm -rf "$Work"' EXIT

7z e -o"$Work" -y "$Zip" > /dev/null 2>&1 || {
    echo "probe-error: 7z extraction failed for $Zip" >&2
    exit 1
}

Wad=""
for f in "$Work"/*; do
    [ -f "$f" ] || continue
    case "$(basename "$f")" in
        *.wad|*.WAD|*.Wad) Wad="$f"; break ;;
    esac
done

[ -n "$Wad" ] || {
    echo "probe-error: no .wad inside $Zip" >&2
    exit 1
}

Header="$(head -c 4 "$Wad")"
case "$Header" in
    PWAD|IWAD) echo "HEADER=$Header" ;;
    *) echo "probe-error: unknown header '$Header' in $Wad" >&2; exit 1 ;;
esac
exit 0
