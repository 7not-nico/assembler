#!/usr/bin/env bash
# append-upsert-test.sh — fixture: schema protocols on a scratch WADS_DB.
# Run:   bash fixture/append-upsert-test.sh
# Proves append (INSERT OR IGNORE + dup guard) and upsert (INSERT OR REPLACE)
# on a hermetic db + custom dir before the live registry is trusted.

set -uo pipefail

S="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$S/.." && pwd)"
Sample="$S/sample"
Seeds="$Root/schema/seeds/00-ddl.sql"
Append="$Root/schema/scripts/append.sh"
Upsert="$Root/schema/scripts/upsert.sh"
Work="$(mktemp -d)"
trap 'rm -rf "$Work"' EXIT

Fail=0
fail() { echo "FAIL $1"; Fail=1; }

bash "$S/sample/build.sh" > /dev/null || fail "sample build"

Db="$Work/scratch.db"
Custom="$Work/custom"
mkdir -p "$Custom"
cp "$Sample/sample-pwad.zip" "$Custom/sample-pwad.zip"
cp "$Sample/sample-upper.zip" "$Custom/upper.zip"
sqlite3 "$Db" < "$Seeds" || fail "ddl apply"

# append new
Out="$(WADS_DB="$Db" CUSTOM_DIR="$Custom" bash "$Append" sample-pwad.zip "Sample WAD" "Fixture" doom map 01/01/01 levels/x/sample-pwad.zip "https://example.test/levels/x/sample-pwad.zip")" || fail "append exit"
if echo "$Out" | rg -q '^APPENDED=1$'; then echo "ok   append new"; else fail "append APPENDED=1"; fi

# append duplicate must fail
if WADS_DB="$Db" CUSTOM_DIR="$Custom" bash "$Append" sample-pwad.zip "Sample WAD" "Fixture" doom map 01/01/01 levels/x/sample-pwad.zip "https://example.test/levels/x/sample-pwad.zip" > /dev/null 2>&1; then
    fail "append dup should error"
else
    echo "ok   append dup guard"
fi

# upsert existing -> updated
Out="$(WADS_DB="$Db" CUSTOM_DIR="$Custom" bash "$Upsert" sample-pwad.zip "Sample WAD v2" "Fixture" doom map 01/01/01 levels/x/sample-pwad.zip "https://example.test/levels/x/sample-pwad.zip")" || fail "upsert exit"
if echo "$Out" | rg -q '^MODE=updated$'; then echo "ok   upsert updated"; else fail "upsert updated"; fi

# upsert absent -> inserted
Out="$(WADS_DB="$Db" CUSTOM_DIR="$Custom" bash "$Upsert" upper.zip "Upper WAD" "Fixture" doom2 map 01/01/01 levels/x/upper.zip "https://example.test/levels/x/upper.zip")" || fail "upsert insert exit"
if echo "$Out" | rg -q '^MODE=inserted$'; then echo "ok   upsert inserted"; else fail "upsert inserted"; fi

# integrity
Count="$(sqlite3 "$Db" "SELECT count(*), count(DISTINCT url) FROM wad_sources;")"
if [ "$Count" = "2|2" ]; then echo "ok   integrity 2 rows / 2 distinct urls"; else fail "integrity count"; fi

[ "$Fail" -eq 0 ]
