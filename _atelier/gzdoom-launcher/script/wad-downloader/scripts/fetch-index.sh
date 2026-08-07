#!/usr/bin/env bash
# fetch-index.sh — fetch an idgames directory index and list its links.
# Usage: bash fetch-index.sh <path> [--zips] [--dirs]
# Contract: one task per script; args in, keyed result lines out; diagnostics to stderr; non-zero on failure.

set -uo pipefail

Base="https://www.gamers.org/pub/idgames"
Path="${1:-}"
Show="${2:-all}"

if [ -z "$Path" ]; then
    echo "usage: fetch-index.sh <path> [--zips|--dirs|all]" >&2
    exit 1
fi

Url="$Base/$Path"

Html=""
for Try in 1 2 3; do
    Html="$(curl -sL --max-time 25 -A "wad-downloader/0.1" "$Url")" || {
        echo "fetch-error: curl failed for $Url (try $Try)" >&2
        sleep 3
        continue
    }
    if [ "${#Html}" -lt 1000 ]; then
        echo "truncate-warn: response ${#Html} bytes, retrying (try $Try)" >&2
        sleep 3
        continue
    fi
    break
done
if [ "${#Html}" -lt 1000 ]; then
    echo "fetch-error: truncated response for $Url after 3 tries" >&2
    exit 1
fi

Zips="$(printf '%s' "$Html" | rg -o 'href="[^"]+\.zip"' | sed 's/href="//; s/"$//' | sort -u)"
Dirs="$(printf '%s' "$Html" | rg -o 'href="[^"]+/"' | sed 's/href="//; s/"$//' | rg -v '^/' | sort -u)"

CountZips="$(printf '%s' "$Zips" | rg -c '.' || true)"
CountDirs="$(printf '%s' "$Dirs" | rg -c '.' || true)"

case "$Show" in
    --zips) printf '%s\n' "$Zips" ;;
    --dirs) printf '%s\n' "$Dirs" ;;
    *)      printf '%s\n' "$Zips" "$Dirs" ;;
esac

echo "ZIPS=$CountZips"
echo "DIRS=$CountDirs"
exit 0
