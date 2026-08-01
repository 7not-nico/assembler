#!/usr/bin/env bash
# prepare-paper.sh — move a downloaded PDF into the catalog with a slug name
# Usage: bash prepare-paper.sh {pdf} {domain} {subdomain} [filename]
# Slugifies the filename via slugify.sh, moves into {domain}/{subdomain}/,
# prints PAPER=<path>. Optional explicit filename overrides the slug.
set -uo pipefail

PDF="${1:?pdf required}"
DOMAIN="${2:?domain required}"
SUBDOMAIN="${3:?subdomain required}"
[ -f "$PDF" ] || { echo "ERROR no such file: $PDF" >&2; exit 1; }

HERE="$(cd "$(dirname "$0")" && pwd)"
TROVE="$(cd "$HERE/.." && pwd)"
CATDIR="$TROVE/$DOMAIN/$SUBDOMAIN"
mkdir -p "$CATDIR"

SLUG="$(bash "$HERE/slugify.sh" "$(basename "$PDF")")"
PAPER="$CATDIR/${4:-$SLUG}"
mv "$PDF" "$PAPER"
echo "PAPER $PAPER"
