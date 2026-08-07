#!/usr/bin/env bash
# append.sh — append one download record to schema/wads.db (new WAD only).
# Usage: bash append.sh <file> <title> <author> <game> <kind> <date> <source> <url>
# Protocol: INSERT OR IGNORE (append-if-absent); existing file or url -> error, use upsert.sh.
# size_bytes/sha256/header derive from the artifact in wad/custom/, never from args.
# Contract: one task per script; keyed result lines out; non-zero on failure.

set -uo pipefail

Scripts="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$Scripts/../.." && pwd)"
Db="${WADS_DB:-$Root/schema/wads.db}"
Custom="${CUSTOM_DIR:-$Root/wad/custom}"

File="${1:-}"; Title="${2:-}"; Author="${3:-}"; Game="${4:-}"; Kind="${5:-}"; Date="${6:-}"; Source="${7:-}"; Url="${8:-}"

if [ -z "$File" ] || [ -z "$Title" ] || [ -z "$Source" ] || [ -z "$Url" ]; then
    echo "usage: append.sh <file> <title> <author> <game> <kind> <date> <source> <url>" >&2
    exit 1
fi

Artifact="$Custom/$File"
[ -f "$Artifact" ] || {
    echo "append-error: artifact missing: $Artifact (run download.sh first)" >&2
    exit 1
}

SqlEscape() { printf '%s' "$1" | sed "s/'/''/g"; }
Exists="$(sqlite3 "$Db" "SELECT count(*) FROM wad_sources WHERE file='$(SqlEscape "$File")' OR url='$(SqlEscape "$Url")';")"
[ "$Exists" = "0" ] || {
    echo "append-error: $File already registered — use upsert.sh to update" >&2
    exit 1
}

Size="$(stat -c%s "$Artifact")"
Sha="$(sha256sum "$Artifact" | cut -d' ' -f1)"
Header="$(bash "$Scripts/probe-header.sh" "$Artifact" | rg '^HEADER=' | cut -d= -f2)"

sqlite3 "$Db" "INSERT OR IGNORE INTO wad_sources (file, title, author, game, kind, size_bytes, sha256, date, source, url, header) VALUES ('$(SqlEscape "$File")','$(SqlEscape "$Title")','$(SqlEscape "$Author")','$(SqlEscape "$Game")','$(SqlEscape "$Kind")',$Size,'$Sha','$(SqlEscape "$Date")','$(SqlEscape "$Source")','$(SqlEscape "$Url")','$Header');" || {
    echo "append-error: sqlite insert failed" >&2
    exit 1
}

echo "APPENDED=1"
echo "FILE=$File"
echo "URL=$Url"
echo "SHA256=$Sha"
echo "HEADER=$Header"
exit 0
