#!/usr/bin/env bash
# batch-download.sh — run the download chain over a list of idgames paths.
# Usage: bash batch-download.sh <list-file> [dest-dir]
# List file: one idgames path per line (e.g. levels/doom2/a-c/aaar20.zip).
# Contract: one task per script; keyed result lines out; diagnostics to stderr; non-zero on any failure.

set -uo pipefail

List="${1:-}"
Dest="${2:-wad/custom}"
Scripts="$(dirname "${BASH_SOURCE[0]}")"

if [ -z "$List" ] || [ ! -f "$List" ]; then
    echo "usage: batch-download.sh <list-file> [dest-dir]" >&2
    exit 1
fi

Total=0
Ok=0
Fail=0
while IFS= read -r Path; do
    [ -z "$Path" ] && continue
    Total=$((Total + 1))
    echo "== item $Total: $Path =="
    if bash "$Scripts/download.sh" "$Path" "$Dest"; then
        Ok=$((Ok + 1))
    else
        Fail=$((Fail + 1))
    fi
done < "$List"

echo "DONE=$Ok"
echo "FAILED=$Fail"
echo "TOTAL=$Total"
[ "$Fail" -eq 0 ]
