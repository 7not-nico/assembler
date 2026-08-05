#!/usr/bin/env bash
# slugify.sh — convert a filename to a lowercase dash-slug
# Usage: bash slugify.sh {filename}
# Thin shim over the shared _shared/bin/slugify Go binary; the walk-up
# locates the binary whether this file lives at _templates/shell/ or in a
# dive copy (ancestor discovery).
set -uo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
d="$BASE_DIR"
while [ "$d" != "/" ]; do
  if [ -x "$d/_shared/bin/slugify" ]; then
    exec "$d/_shared/bin/slugify" "$@"
  fi
  d="$(dirname "$d")"
done
echo "ERROR _shared/bin/slugify not found above $BASE_DIR" >&2
exit 1
