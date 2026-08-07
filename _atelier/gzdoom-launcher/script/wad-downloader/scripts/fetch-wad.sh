#!/usr/bin/env bash
# fetch-wad.sh — download one idgames wad zip and verify its archive.
# Usage: bash fetch-wad.sh <path-to-zip> <dest-dir>
# Contract: one task per script; args in, keyed result lines out; diagnostics to stderr; non-zero on failure.

set -uo pipefail

Base="https://www.gamers.org/pub/idgames"
ZipPath="${1:-}"
Dest="${2:-}"

if [ -z "$ZipPath" ] || [ -z "$Dest" ]; then
    echo "usage: fetch-wad.sh <path-to-zip> <dest-dir>" >&2
    exit 1
fi

mkdir -p "$Dest" || exit 1

Name="$(basename "$ZipPath")"
Url="$Base/$ZipPath"
Out="$Dest/$Name"

for Try in 1 2 3; do
    rm -f "$Out"
    curl -sL --max-time 120 -A "wad-downloader/0.1" -o "$Out" "$Url" || {
        echo "download-error: curl failed for $Url (try $Try)" >&2
        sleep 3
        continue
    }
    if 7z t "$Out" > /dev/null 2>&1; then
        break
    fi
    echo "verify-warn: $Out failed archive test (try $Try)" >&2
    sleep 3
done

if ! 7z t "$Out" > /dev/null 2>&1; then
    echo "verify-error: $Out is not a valid zip archive after 3 tries" >&2
    exit 1
fi

Size="$(stat -c%s "$Out")"
echo "WAD=$Out"
echo "SIZE=$Size"
exit 0
