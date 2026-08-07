#!/usr/bin/env bash
# build.sh — generate the offline sample zips for the launcher fixtures.
# Creates: sample-pwad.zip (PWAD wad + txt), sample-iwad.zip (IWAD wad),
#          sample-upper.zip (uppercase HOOVER.WAD), sample-nowad.zip (txt only).
# Idempotent: 7z a overwrites; temp wad files removed after zipping.

set -uo pipefail

Sample="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$Sample" || exit 1

{ printf 'PWAD'; head -c 1020 /dev/zero; } > sample-pwad.wad
{ printf 'IWAD'; head -c 1020 /dev/zero; } > sample-iwad.wad
{ printf 'PWAD'; head -c 1020 /dev/zero; } > HOOVER.WAD
printf 'sample readme\n' > readme.txt

7z a -tzip -y sample-pwad.zip sample-pwad.wad readme.txt > /dev/null
7z a -tzip -y sample-iwad.zip sample-iwad.wad > /dev/null
7z a -tzip -y sample-upper.zip HOOVER.WAD > /dev/null
7z a -tzip -y sample-nowad.zip readme.txt > /dev/null

rm -f sample-pwad.wad sample-iwad.wad HOOVER.WAD readme.txt
echo "SAMPLE=built"
exit 0
