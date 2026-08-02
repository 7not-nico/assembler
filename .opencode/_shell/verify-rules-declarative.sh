#!/usr/bin/env bash
# verify-rules-declarative.sh — scan .opencode/rules/*.md for non-declarative directive forms
# Verifies RUL.COMMUNICATION.DECLARATIVE + RUL.WRITING.DECLARATIVE.OVER.IMPERATIVE compliance.
# Emits keyed lines (VIOLATION= COUNT= FILES_SCANNED= VIOLATIONS= RESULT=); exit 1 on violations.
# Usage: bash verify-rules-declarative.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RULES_DIR="$ROOT/.opencode/rules"
PATTERN='\b(must|should|never|don'"'"'t|do not|always|avoid)\b|!'

total=0
violations=0
for f in "$RULES_DIR"/*.md; do
  base=$(basename "$f")
  total=$((total + 1))
  # Strip quoted spans (examples) and entity-ID reference lines, then scan for modal/imperative markers
  hits=$(sed 's/"[^"]*"//g' "$f" | rg -in "$PATTERN" | rg -v 'RUL\.|PROT\.|REF\.|MAX\.|PAT\.|NEX\.|ILL\.|SPEC\.|IDENTITY\.' || true)
  if [ -n "$hits" ]; then
    count=$(printf '%s\n' "$hits" | rg -c .)
    violations=$((violations + count))
    echo "VIOLATION=$base COUNT=$count"
    printf '%s\n' "$hits" | sed 's/^/  /'
  fi
done

echo "FILES_SCANNED=$total"
echo "VIOLATIONS=$violations"
if [ "$violations" -eq 0 ]; then
  echo "RESULT=pass:0"
else
  echo "RESULT=fail:$violations"
  exit 1
fi
