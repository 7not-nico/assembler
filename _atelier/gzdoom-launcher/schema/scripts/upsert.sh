#!/usr/bin/env bash
# upsert.sh — update-or-insert one download record in schema/wads.db.
# Usage: bash upsert.sh <file> <title> <author> <game> <kind> <date> <source> <url>
# Protocol: INSERT OR REPLACE keyed on file; existing row -> replaced (MODE=updated),
#           absent -> inserted (MODE=inserted).
# size_bytes/sha256/header derive from the artifact in wad/custom/, never from args.
# Contract: one task per script; keyed result lines out; non-zero on failure.

set -uo pipefail

Scripts="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$Scripts/../.." && pwd)"
Db="${WADS_DB:-$Root/schema/wads.db}"
Custom="${CUSTOM_DIR:-$Root/wad/custom}"

File="${1:-}"; Title="${2:-}"; Author="${3:-}"; Game="${4:-}"; Kind="${5:-}"; Date="${6:-}"; Source="${7:-}"; Url="${8:-}"

if [ -z "$File" ] || [ -z "$Title" ] || [ -z "$Source" ] || [ -z "$Url" ]; then
    echo "usage: upsert.sh <file> <title> <author> <game> <kind> <date> <source> <url>" >&2
    exit 1
fi

Artifact="$Custom/$File"
[ -f "$Artifact" ] || {
    echo "upsert-error: artifact missing: $Artifact (run download.sh first)" >&2
    exit 1
}

SqlEscape() { printf '%s' "$1" | sed "s/'/''/g"; }
Mode="inserted"
Exists="$(sqlite3 "$Db" "SELECT count(*) FROM wad_sources WHERE file='$(SqlEscape "$File")';")"
[ "$Exists" = "0" ] || Mode="updated"

Size="$(stat -c%s "$Artifact")"
Sha="$(sha256sum "$Artifact" | cut -d' ' -f1)"
Header="$(bash "$Scripts/probe-header.sh" "$Artifact" | rg '^HEADER=' | cut -d= -f2)"

sqlite3 "$Db" "INSERT OR REPLACE INTO wad_sources (file, title, author, game, kind, size_bytes, sha256, date, source, url, header) VALUES ('$(SqlEscape "$File")','$(SqlEscape "$Title")','$(SqlEscape "$Author")','$(SqlEscape "$Game")','$(SqlEscape "$Kind")',$Size,'$Sha','$(SqlEscape "$Date")','$(SqlEscape "$Source")','$(SqlEscape "$Url")','$Header');" || {
    echo "upsert-error: sqlite upsert failed" >&2
    exit 1
}

echo "UPSERTED=1"
echo "FILE=$File"
echo "MODE=$Mode"
echo "URL=$Url"
echo "SHA256=$Sha"
echo "HEADER=$Header"
exit 0
