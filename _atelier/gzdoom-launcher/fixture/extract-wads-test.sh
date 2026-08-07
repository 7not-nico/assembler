#!/usr/bin/env bash
# extract-wads-test.sh — fixture: extract-wads.sh moves any-case .wad entries.
# Run:   bash fixture/extract-wads-test.sh
# Proves lowercase, uppercase, and absent .wad handling before fetch-temp uses the helper.

set -uo pipefail

S="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$S/.." && pwd)"
Sample="$S/sample"
Helper="$Root/script/wad-downloader/scripts/extract-wads.sh"
Work="$(mktemp -d)"
trap 'rm -rf "$Work"' EXIT

Fail=0
fail() { echo "FAIL $1"; Fail=1; }

bash "$S/sample/build.sh" > /dev/null || fail "sample build"

# lowercase pwad zip
Out="$(bash "$Helper" "$Sample/sample-pwad.zip" "$Work/lower")" || fail "pwad extract exit"
echo "$Out" | rg -q '^EXTRACTED=1$' || fail "pwad EXTRACTED=1"
[ -f "$Work/lower/sample-pwad.wad" ] || fail "pwad wad present"
echo "ok   pwad extract"

# uppercase wad zip (HOOVER.WAD shape)
Out="$(bash "$Helper" "$Sample/sample-upper.zip" "$Work/upper")" || fail "upper extract exit"
echo "$Out" | rg -q '^EXTRACTED=1$' || fail "upper EXTRACTED=1"
[ -f "$Work/upper/HOOVER.WAD" ] || fail "upper wad present"
echo "ok   uppercase extract"

# no-wad zip must fail
if bash "$Helper" "$Sample/sample-nowad.zip" "$Work/none" > /dev/null 2>&1; then
    fail "no-wad zip should error"
else
    echo "ok   no-wad zip errors"
fi

[ "$Fail" -eq 0 ]
