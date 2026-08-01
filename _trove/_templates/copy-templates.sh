#!/usr/bin/env bash
# copy-templates.sh — copy the knowledge + codex template structure into a target dir
# Usage: bash copy-templates.sh {target-dir}
# Copies _knowledge/_templates/ → {target-dir}/ preserving subdirectories
# (the 13-layer chain), then the codex-specific templates from
# _codex/_templates/ (pattern, atomic-script, precedence-chain, tooling).
# Adds/overwrites template files; leaves existing non-template files untouched.
set -euo pipefail

TARGET="${1:?target-dir required}"
HERE="$(cd "$(dirname "$0")" && pwd)"
KNOWLEDGE_SOURCE="$(cd "$HERE/../../_knowledge/_templates" && pwd)"

mkdir -p "$TARGET"
cp -a "$KNOWLEDGE_SOURCE/." "$TARGET/"
echo "COPY   $KNOWLEDGE_SOURCE → $TARGET"

# codex-specific dive templates + tooling
CODEX_FILES=(pattern-template.md atomic-script-template.sh precedence-chain.md
             start-browser.sh start-browser-headless.sh run-logged.sh slugify.sh)
for f in "${CODEX_FILES[@]}"; do
  if [ -f "$HERE/$f" ]; then
    cp -a "$HERE/$f" "$TARGET/$f"
    echo "COPY   $HERE/$f → $TARGET/$f"
  fi
done

echo "DONE   $TARGET"
