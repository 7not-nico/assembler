#!/usr/bin/env bash
# scaffold-knowledge.sh — create a new knowledge project from templates
# Usage: bash scaffold-knowledge.sh {project-name} "{domain statement}" [--with-skills]
#   --with-skills: copy anchored skills into docs/ (anchor-workflow pattern)
# Creates: _knowledge/{name}/ with full chain structure + AGENTS.md

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

# Chain directories
mkdir -p "$DEST"/{format,precept,procedure,research,concept,note,bitacora,glossary,schema,script,reference,fixtures,practice,docs}

# AGENTS.md from template
sed -e "s|{PROJECT-NAME}|$NAME|g" -e "s|{domain statement}|$DOMAIN|g" -e "s|{domain}|$DOMAIN|g" \
  "$ROOT/_templates/AGENTS.template.md" > "$DEST/AGENTS.md"

# Copy remaining templates as reference boilerplate
cp "$ROOT/_templates"/format-template.md   "$DEST/format/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/precept-template.md  "$DEST/precept/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/write-report-template.md "$DEST/precept/write-report.md" 2>/dev/null || true
cp "$ROOT/_templates"/procedure-template.md "$DEST/procedure/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/browse-playwright-template.md "$DEST/procedure/.browse-playwright.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/research-template.md  "$DEST/research/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/concept-template.md   "$DEST/concept/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/note-template.md      "$DEST/note/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/bitacora-template.md  "$DEST/bitacora/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/glossary-template.md  "$DEST/glossary/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/reference-template.md "$DEST/reference/.template.md" 2>/dev/null || true
cp "$ROOT/_templates"/naming-conventions-template.md "$DEST/reference/naming-conventions.md" 2>/dev/null || true
cp "$ROOT/_templates"/practice-template.md  "$DEST/practice/.template.md" 2>/dev/null || true

# Schema + script (name from project)
SCHEMA_NAME="${NAME//-/_}"
sed "s/{NAME}/$SCHEMA_NAME/g" "$ROOT/_templates/schema-template.sql" > "$DEST/schema/$SCHEMA_NAME.sql"
sed -e "s/{ACTION}-{SUBJECT}/push-registry/g" -e "s/{action}-{subject}/push-registry/g" -e "s/{NAME}/$SCHEMA_NAME/g" \
  "$ROOT/_templates/push-script-template.rb" > "$DEST/script/push-registry.rb"
chmod +x "$DEST/script/push-registry.rb"

# Anchor workflow: copy skills into docs/ (optional --with-skills)
if [ "$WITH_SKILLS" -eq 1 ]; then
  bash "$ROOT/_templates/copy-skills.sh" "$DEST/docs" \
    compose-web orchestrate-research study-foundations search-papers \
    use-playwright-core use-playwright-ai-mode use-playwright-debug \
    use-playwright-network-storage use-playwright-vision \
    use-parallel-search use-exa use-context-seven \
    read-maxims-protocols guide-reasoning report-outcomes query-nerdfont
fi

echo "Scaffolded $DEST"
echo "Chain: format → precept → procedure → research → concept → note → bitacora → glossary → schema → script → reference → fixtures → practice"
