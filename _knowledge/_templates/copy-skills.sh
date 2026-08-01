#!/usr/bin/env bash
# copy-skills.sh — copy SKILL.md files into a subproject docs/ dir, flattened
# Usage: bash copy-skills.sh {dest-docs-dir} {skill-name}...
# Copies each {skill}/SKILL.md → {dest-docs-dir}/{skill}.md
set -euo pipefail

DEST="${1:?dest-docs-dir required}"
shift
SKILLS_ROOT="$(cd "$(dirname "$0")/../../.opencode/skills" && pwd)"

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
