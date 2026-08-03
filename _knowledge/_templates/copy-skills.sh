#!/usr/bin/env bash
# copy-skills.sh — symlink SKILL.md dirs into a subproject skills/ dir
# Usage: bash copy-skills.sh {dest-skills-dir} {skill-name}...
# Source: .opencode/skills/ — the canonical live skill set.
# Links each {skill}/ dir → {dest-skills-dir}/{skill}/ — no copies, no staleness.
# Workspace skills resolve relative (../../../.opencode/skills/{skill}).
set -euo pipefail

DEST="${1:?dest-skills-dir required}"
shift
SKILLS_ROOT="$(cd "$(dirname "$0")/../../.opencode/skills" && pwd)"
DEST_ABS="$(cd "$DEST" 2>/dev/null && pwd || echo "$DEST")"

mkdir -p "$DEST"
for skill in "$@"; do
  src="$SKILLS_ROOT/$skill"
  if [ -d "$src" ]; then
    # relative link from dest back to workspace source
    rel="$(python3 -c "import os,sys;print(os.path.relpath('$src','$DEST_ABS'))")"
    ln -sfn "$rel" "$DEST/$skill"
    echo "  SKILL $skill → $rel"
  else
    echo "  MISS  $skill (not found in $SKILLS_ROOT)"
  fi
done
