#!/usr/bin/env bash
# copy-templates.sh — copy the knowledge + codex template structure into a target dir
# Usage: bash copy-templates.sh {target-dir}
# Copies _knowledge/_templates/ → {target-dir}/ preserving subdirectories
# (the 13-layer chain), then the codex-specific templates from
# _codex/_templates/ (pattern, atomic-script, precedence-chain, tooling).
# Location-aware: resolves the _codex root whether the script lives at
# _templates/, _templates/shell/, or _templates/script/ (template files at
# root, shells in shell/, scripts in script/).
set -euo pipefail

TARGET="${1:?target-dir required}"
# shellcheck source=deps/paths.sh
. "$(cd "$(dirname "$0")" && pwd)/deps/paths.sh"
root_vars "$(cd "$(dirname "$0")" && pwd)"
CODEX_TEMPLATES="$TEMPLATES"
KNOWLEDGE_SOURCE="$(cd "$CODEX_TEMPLATES/../../_knowledge/_templates" && pwd)"
mkdir -p "$TARGET"
cp -a "$KNOWLEDGE_SOURCE/." "$TARGET/"
echo "COPY   $KNOWLEDGE_SOURCE → $TARGET"

# codex-specific dive templates (at _templates root) + tooling (in shell/)
CODEX_FILES=(pattern-template.md atomic-script-template.sh precedence-chain.md
             invariant-template.md guideline-template.md
             study-template.md fixture-template.md backup-template.md dive-agents-template.md
             dive-naming-conventions-template.md
             precept-verify-qalc-template.md precept-record-metrics-template.md
             precept-run-fixtures-template.md precept-atomic-documents-template.md
             precept-use-ripgrep-template.md precept-use-shared-browser-template.md)
SHELL_FILES=(start-browser.sh start-browser-headless.sh run-logged.sh slugify.sh)
for f in "${CODEX_FILES[@]}"; do
  if [ -f "$CODEX_TEMPLATES/$f" ]; then
    cp -a "$CODEX_TEMPLATES/$f" "$TARGET/$f"
    echo "COPY   $CODEX_TEMPLATES/$f → $TARGET/$f"
  fi
done
for f in "${SHELL_FILES[@]}"; do
  if [ -f "$CODEX_TEMPLATES/shell/$f" ]; then
    cp -a "$CODEX_TEMPLATES/shell/$f" "$TARGET/$f"
    echo "COPY   $CODEX_TEMPLATES/shell/$f → $TARGET/$f"
  fi
done
# shell deps ride along — the copies source deps/{logger,browser,paths}.sh
if [ -d "$CODEX_TEMPLATES/shell/deps" ]; then
  cp -a "$CODEX_TEMPLATES/shell/deps" "$TARGET/deps"
  echo "COPY   $CODEX_TEMPLATES/shell/deps → $TARGET/deps"
fi
# _shared rides along — deps exec the _shared/bin Go binaries
if [ -d "$CODEX_TEMPLATES/_shared" ]; then
  cp -a "$CODEX_TEMPLATES/_shared" "$TARGET/_shared"
  echo "COPY   $CODEX_TEMPLATES/_shared → $TARGET/_shared"
fi

echo "DONE   $TARGET"
