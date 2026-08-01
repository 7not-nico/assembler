#!/usr/bin/env bash
# bitacora-slugify.sh — convert a topic to a lowercase dash-slug for record names
# Repurposed from _codex/_templates/shell/slugify.sh (identical logic)
# Usage: bash bitacora-slugify.sh {topic}
# Spaces, punctuation, case → lowercase dash-slug; dashes collapse.
set -euo pipefail

NAME="${1:?topic required}"
echo "$NAME" | tr '[:upper:]' '[:lower:]' \
  | tr -c '[:alnum:]' '-' \
  | sed -E 's/-+/-/g; s/^-+//; s/-+$//'
