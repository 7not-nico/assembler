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
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TEMPLATES="$ROOT/_templates"
KNOWLEDGE_ROOT="$(cd "$ROOT/.." && pwd)/_knowledge"
DEST="$KNOWLEDGE_ROOT/$NAME"

if [ -d "$DEST" ]; then
  echo "ERROR: $DEST exists" >&2
  exit 1
fi

# Chain directories
mkdir -p "$DEST"/{format,precept,procedure,research,concept,note,bitacora,glossary,schema,script,reference,fixtures,practice,docs}

# AGENTS.md from template
sed -e "s|{PROJECT-NAME}|$NAME|g" -e "s|{domain statement}|$DOMAIN|g" -e "s|{domain}|$DOMAIN|g" \
  "$TEMPLATES/AGENTS.template.md" > "$DEST/AGENTS.md"

# Copy remaining templates as reference boilerplate
cp "$TEMPLATES"/format-template.md   "$DEST/format/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/precept-template.md  "$DEST/precept/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/write-report-template.md "$DEST/precept/write-report.md" 2>/dev/null || true
cp "$TEMPLATES"/procedure-template.md "$DEST/procedure/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/browse-playwright-template.md "$DEST/procedure/.browse-playwright.template.md" 2>/dev/null || true
cp "$TEMPLATES"/research-template.md  "$DEST/research/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/concept-template.md   "$DEST/concept/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/note-template.md      "$DEST/note/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/bitacora-template.md  "$DEST/bitacora/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/glossary-template.md  "$DEST/glossary/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/reference-template.md "$DEST/reference/.template.md" 2>/dev/null || true
cp "$TEMPLATES"/naming-conventions-template.md "$DEST/reference/naming-conventions.md" 2>/dev/null || true
cp "$TEMPLATES"/practice-template.md  "$DEST/practice/.template.md" 2>/dev/null || true

# Schema + script (name from project)
SCHEMA_NAME="${NAME//-/_}"
sed "s/{NAME}/$SCHEMA_NAME/g" "$TEMPLATES/schema-template.sql" > "$DEST/schema/$SCHEMA_NAME.sql"
sed -e "s/{ACTION}-{SUBJECT}/push-registry/g" -e "s/{action}-{subject}/push-registry/g" -e "s/{NAME}/$SCHEMA_NAME/g" \
  "$TEMPLATES/push-script-template.rb" > "$DEST/script/push-registry.rb"
chmod +x "$DEST/script/push-registry.rb"

# Anchor workflow: copy skills into docs/ (optional --with-skills)
if [ "$WITH_SKILLS" -eq 1 ]; then
  bash "$TEMPLATES/script/copy-skills.sh" "$DEST/docs" \
    compose-web orchestrate-research study-foundations search-papers \
    use-playwright-core use-playwright-ai-mode use-playwright-debug \
    use-playwright-network-storage use-playwright-vision \
    use-parallel-search use-exa use-context-seven \
    read-maxims-protocols guide-reasoning report-outcomes query-nerdfont
fi

echo "Scaffolded $DEST"
echo "Chain: format → precept → procedure → research → concept → note → bitacora → glossary → schema → script → reference → fixtures → practice"
