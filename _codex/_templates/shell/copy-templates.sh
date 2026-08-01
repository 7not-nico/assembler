#!/usr/bin/env bash
# copy-templates.sh — copy the knowledge + codex template structure into a target dir
# Usage: bash copy-templates.sh {target-dir}
# Copies _knowledge/_templates/ → {target-dir}/ preserving subdirectories
# (the 13-layer chain), then the codex-specific templates from
# _codex/_templates/ (pattern, atomic-script, precedence-chain, tooling).
# Location-aware: resolves the _codex root whether the script lives at
# _templates/ or _templates/shell/ (template files at root, shells in shell/).
# Adds/overwrites template files; leaves existing non-template files untouched.
set -euo pipefail

TARGET="${1:?target-dir required}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
case "$SCRIPT_DIR" in
  */_templates/shell) CODEX_TEMPLATES="$(cd "$SCRIPT_DIR/.." && pwd)" ;;
  */_templates) CODEX_TEMPLATES="$SCRIPT_DIR" ;;
  *) echo "ERROR copy-templates.sh must live under _codex/_templates[/shell]" >&2; exit 1 ;;
esac
KNOWLEDGE_SOURCE="$(cd "$CODEX_TEMPLATES/../../_knowledge/_templates" && pwd)"

mkdir -p "$TARGET"
cp -a "$KNOWLEDGE_SOURCE/." "$TARGET/"
echo "COPY   $KNOWLEDGE_SOURCE → $TARGET"

# codex-specific dive templates (at _templates root) + tooling (in shell/)
CODEX_FILES=(pattern-template.md atomic-script-template.sh precedence-chain.md
             invariant-template.md guideline-template.md
             study-template.md fixture-template.md backup-template.md dive-agents-template.md)
SHELL_FILES=(start-browser.sh start-browser-headless.sh run-logged.sh slugify.sh)
for f in "${CODEX_FILES[@]}"; do
  if [ -f "$CODEX_TEMPLATES/$f" ]; then
    cp -a "$CODEX_TEMPLATES/$f" "$TARGET/$f"
    echo "COPY   $CODEX_TEMPLATES/$f → $TARGET/$f"
  fi
done
for f in "${SHELL_FILES[@]}"; do
  if [ -f "$SCRIPT_DIR/$f" ]; then
    cp -a "$SCRIPT_DIR/$f" "$TARGET/$f"
    echo "COPY   $SCRIPT_DIR/$f → $TARGET/$f"
  fi
done

echo "DONE   $TARGET"
