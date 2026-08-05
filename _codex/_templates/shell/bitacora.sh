#!/usr/bin/env bash
# bitacora.sh — the bitacora flow binary, cited by name
# Usage: bash bitacora.sh {todo|run|report} ...
# Thin shim over the shared _shared/bin/bitacora Go binary; the walk-up
# locates the binary whether this file lives at _templates/shell/ or in a
# dive copy (ancestor discovery). All framing, records, and exit codes come
# from the binary — this file carries resolution only.
set -uo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
d="$BASE_DIR"
while [ "$d" != "/" ]; do
  if [ -x "$d/_shared/bin/bitacora" ]; then
    exec "$d/_shared/bin/bitacora" "$@"
  fi
  d="$(dirname "$d")"
done
echo "ERROR _shared/bin/bitacora not found above $BASE_DIR" >&2
exit 1
