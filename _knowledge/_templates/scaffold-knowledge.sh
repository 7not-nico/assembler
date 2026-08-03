#!/usr/bin/env bash
# scaffold-knowledge.sh — create a new knowledge project from templates
# Usage: bash scaffold-knowledge.sh {project-name} "{domain statement}" [--with-skills]
#   --with-skills: copy anchored skills into skills/ (anchor-workflow pattern)
# Creates: _knowledge/{name}/ with the lean chain + AGENTS.md
# Lean chain (per rust-docs): precept → concept → reference → fixture; script parallel.
# Full 13-layer chain reference lives in precedence-chain.md.

set -euo pipefail

NAME="$1"
DOMAIN="${2:-Knowledge project}"
WITH_SKILLS=0
for arg in "${@:3}"; do
  case "$arg" in
    --with-skills) WITH_SKILLS=1 ;;
  esac
done
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/$NAME"

if [ -d "$DEST" ]; then
  echo "ERROR: $DEST exists" >&2
  exit 1
fi

# Lean chain directories
mkdir -p "$DEST"/{precept,concept,reference,fixture,script,rings}

# AGENTS.md from template
sed -e "s|{PROJECT-NAME}|$NAME|g" -e "s|{domain statement}|$DOMAIN|g" -e "s|{domain}|$DOMAIN|g" \
  "$ROOT/_templates/AGENTS.template.md" > "$DEST/AGENTS.md"

# Copy layer templates as reference boilerplate
cp "$ROOT/_templates"/precept-template.md   "$DEST/precept/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/report/report-template.md "$DEST/precept/write-report.md" 2>/dev/null || true
cp "$ROOT/_templates"/concept-template.md   "$DEST/concept/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/reference-template.md "$DEST/reference/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/naming-conventions-template.md "$DEST/reference/naming-conventions.md" 2>/dev/null || true
cp "$ROOT/_templates"/fixture-template.md   "$DEST/fixture/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/run-logged-template.sh "$DEST/script/run-logged.sh" 2>/dev/null || true
chmod +x "$DEST/script/run-logged.sh" 2>/dev/null || true

# Ring specifications: copy the ring-topology family into rings/
bash "$ROOT/_templates/copy-rings.sh" "$DEST/rings"

# Anchor workflow: copy skills into skills/ (optional --with-skills)
if [ "$WITH_SKILLS" -eq 1 ]; then
  bash "$ROOT/_templates/copy-skills.sh" "$DEST/skills" \
    study-foundations knowledge-languages \
    reason-quantitative reason-verbal reason-invariants \
    semantic-dispatcher search-dispatcher playwright-dispatcher workflow-dispatcher \
    refactor-skill
fi

echo "Scaffolded $DEST"
echo "Chain: precept → concept → reference → fixture (script + rings parallel)"
