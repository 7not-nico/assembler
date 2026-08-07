#!/usr/bin/env bash
# download.sh — orchestrator: browse idgames directory, pick a wad, fetch, verify.
# Usage: bash download.sh <path-to-wad-zip> [dest-dir]
# Stage chain: fetch-index (read) -> fetch-wad (write) per NEX.ACQUIRE.PIPELINE.
# Contract: one entry point; keyed lines feed stages; stop the chain on failure.

set -uo pipefail

ZipPath="${1:-}"
Dest="${2:-wad/custom}"

if [ -z "$ZipPath" ]; then
    echo "usage: download.sh <path-to-wad-zip> [dest-dir]" >&2
    echo "  path like: levels/doom2/a-c/aaar20.zip" >&2
    exit 1
fi

ProjectRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DestDir="$ProjectRoot/$Dest"

DirPath="$(dirname "$ZipPath")"
echo "== stage 1: index $DirPath =="
bash "$(dirname "${BASH_SOURCE[0]}")/fetch-index.sh" "$DirPath" --zips > /tmp/opencode/idgames-index.txt || exit 1
rg -Fx "$(basename "$ZipPath")" /tmp/opencode/idgames-index.txt > /dev/null || {
    echo "index-error: $ZipPath not listed in $DirPath" >&2
    exit 1
}
echo "index ok: $(basename "$ZipPath") present"

echo "== stage 2: fetch $ZipPath =="
Keyed="$(bash "$(dirname "${BASH_SOURCE[0]}")/fetch-wad.sh" "$ZipPath" "$DestDir")" || exit 1
echo "$Keyed"
Wad="$(echo "$Keyed" | rg '^WAD=' | cut -d= -f2)"
Size="$(echo "$Keyed" | rg '^SIZE=' | cut -d= -f2)"

echo "== stage 3: verify =="
if [ -n "$Wad" ] && [ -n "$Size" ]; then
    echo "DOWNLOADED=1"
    echo "TARGET=$DestDir"
    exit 0
fi
exit 1
