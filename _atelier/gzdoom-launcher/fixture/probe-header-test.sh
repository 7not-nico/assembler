#!/usr/bin/env bash
# probe-header-test.sh — fixture: probe-header.sh emits PWAD/IWAD or errors.
# Run:   bash fixture/probe-header-test.sh
# Proves the custom/standalone header assertion before append/upsert trust it.

set -uo pipefail

S="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$S/.." && pwd)"
Sample="$S/sample"
Probe="$Root/schema/scripts/probe-header.sh"
Work="$(mktemp -d)"
trap 'rm -rf "$Work"' EXIT

Fail=0
fail() { echo "FAIL $1"; Fail=1; }

bash "$S/sample/build.sh" > /dev/null || fail "sample build"

H="$(bash "$Probe" "$Sample/sample-pwad.zip" | rg '^HEADER=' | cut -d= -f2)"
if [ "$H" = "PWAD" ]; then echo "ok   pwad header=PWAD"; else fail "pwad header"; fi

H="$(bash "$Probe" "$Sample/sample-iwad.zip" | rg '^HEADER=' | cut -d= -f2)"
if [ "$H" = "IWAD" ]; then echo "ok   iwad header=IWAD"; else fail "iwad header"; fi

H="$(bash "$Probe" "$Sample/sample-upper.zip" | rg '^HEADER=' | cut -d= -f2)"
if [ "$H" = "PWAD" ]; then echo "ok   uppercase header=PWAD"; else fail "uppercase header"; fi

if bash "$Probe" "$Sample/sample-nowad.zip" > /dev/null 2>&1; then
    fail "no-wad zip should error"
else
    echo "ok   no-wad zip errors"
fi

[ "$Fail" -eq 0 ]
