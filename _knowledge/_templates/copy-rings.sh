#!/usr/bin/env bash
# copy-rings.sh — copy ring-topology specifications into a subproject rings/ dir
# Usage: bash copy-rings.sh {dest-dir} [spec-name...]
# Default (no names): copies the ring-topology family from
# .opencode/entities/specifications/ — the specs the root AGENTS.md references
# for reasoning, coding, and language-ring decisions.
# With names: copies each named SPEC file → {dest-dir}/{name}.md
set -euo pipefail

DEST="${1:?dest-dir required}"
shift
SPEC_ROOT="$(cd "$(dirname "$0")/../../.opencode/entities/specifications" && pwd)"

DEFAULT_RINGS=(
  "SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY.md"
  "RING.SCRIPT.TOPOLOGY.md"
  "RING.DIRECTORY.TOPOLOGY.md"
  "RING.LANGUAGE.TOPOLOGY.md"
  "SPEC.CODE.ELEMENT.NAME.md"
)

if [ "$#" -gt 0 ]; then
  FILES=("$@")
else
  FILES=("${DEFAULT_RINGS[@]}")
fi

mkdir -p "$DEST"
for spec in "${FILES[@]}"; do
  src="$SPEC_ROOT/$spec"
  if [ -f "$src" ]; then
    cp "$src" "$DEST/$spec"
    echo "  RING $spec → $DEST/$spec"
  else
    echo "  MISS  $spec (not found in $SPEC_ROOT)"
  fi
done
