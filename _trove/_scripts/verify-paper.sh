#!/usr/bin/env bash
# verify-paper.sh — verify a downloaded paper PDF
# Usage: bash verify-paper.sh {file}
# file must report a PDF document; prints OK <file> (<pages> pages).
# Exits non-zero when the file is not a valid PDF.
set -uo pipefail

FILE="${1:?file required}"
[ -f "$FILE" ] || { echo "ERROR no such file: $FILE" >&2; exit 1; }

FT="$(file -b "$FILE")"
case "$FT" in
  *PDF*) ;;
  *) echo "ERROR not a PDF: $FT" >&2; exit 1 ;;
esac

PAGES="$(echo "$FT" | sed -n 's/.*, \([0-9]*\) page(s\?).*/\1/p')"
[ -n "$PAGES" ] || PAGES="?"
echo "OK   $FILE ($PAGES pages)"
