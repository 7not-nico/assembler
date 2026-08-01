#!/usr/bin/env bash
# slugify.sh — convert a filename to a lowercase dash-slug
# Usage: bash slugify.sh {filename}
# Spaces, parentheses, brackets, and punctuation → dashes; dashes collapse;
# leading/trailing dashes strip; single trailing extension preserved.
set -euo pipefail

NAME="${1:?filename required}"

BASE="${NAME%.*}"
EXT="${NAME##*.}"
if [ "$BASE" = "$NAME" ]; then EXT=""; fi

SLUG="$(echo "$BASE" | tr '[:upper:]' '[:lower:]' \
  | tr -c '[:alnum:]' '-' \
  | sed -E 's/-+/-/g; s/^-+//; s/-+$//')"

if [ -n "$EXT" ]; then echo "$SLUG.$EXT"; else echo "$SLUG"; fi
