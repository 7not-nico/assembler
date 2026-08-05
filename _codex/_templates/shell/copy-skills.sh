#!/usr/bin/env bash
# copy-skills.sh — copy SKILL.md files into a subproject docs/ dir, flattened
# Usage: bash copy-skills.sh {dest-docs-dir} {skill-name}...
# Copies each {skill}/SKILL.md → {dest-docs-dir}/{skill}.md
set -euo pipefail

DEST="${1:?dest-docs-dir required}"
shift
# shellcheck source=deps/paths.sh
. "$(cd "$(dirname "$0")" && pwd)/deps/paths.sh"
root_vars "$(cd "$(dirname "$0")" && pwd)"
SKILLS_ROOT="$ASSEMBLER/.opencode/skills"

mkdir -p "$DEST"
for skill in "$@"; do
  src="$SKILLS_ROOT/$skill/SKILL.md"
  if [ -f "$src" ]; then
    cp "$src" "$DEST/$skill.md"
    echo "  SKILL $skill → $DEST/$skill.md"
  else
    echo "  MISS  $skill (not found in $SKILLS_ROOT)"
  fi
done
