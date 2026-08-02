#!/usr/bin/env bash
# fixture-cloth-docs.sh — advanced: docs-vs-code conformance for cloth-config
# Verifies the DOCUMENTED API (from Context7/gitbook, see report) against the
# ACTUAL source in the clone. Three conformance checks:
#   C1 documented builder methods exist in ConfigEntryBuilder.java
#   C2 documented builder-chain setters exist in the builder classes
#   C3 ConfigBuilder.create() entry point exists
# Shape: KEY=value contract; RESULT=pass:conformance|fail:N. Graceful SKIP.
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"           # repo root
CLONE="$ROOT/_sandbox/cloth-config"

if [[ ! -d "$CLONE" ]]; then
  echo "CLOTH_CONFIG=absent"
  echo "RESULT=skip:none"
  exit 0
fi

SRC="$CLONE/common/src/main/java/me/shedaniel/clothconfig2"
BUILDER="$SRC/api/ConfigEntryBuilder.java"

# --- C1: documented option-type methods (from gitbook "Creating a Config Option")
# gitbook uses startStrField; source family is start{Type}Field
DOC_METHODS=(startStrField startAlphaColorField startColorField startDoubleField \
             startFloatField startIntField startKeyCodeField startLongField \
             startTextField)
c1=0
c1_total=0
for m in "${DOC_METHODS[@]}"; do
  c1_total=$((c1_total + 1))
  if rg -q "${m}\(" "$BUILDER" 2>/dev/null; then c1=$((c1 + 1)); fi
done

# --- C2: documented builder-chain setters (setDefaultValue/setTooltip/
# setSaveConsumer/build) exist in the concrete builder classes
DOC_SETTERS=(setDefaultValue setTooltip setSaveConsumer build)
c2=0
c2_total=0
for s in "${DOC_SETTERS[@]}"; do
  c2_total=$((c2_total + 1))
  if rg -lq "public [^;]*${s}\(" "$SRC/impl/builders/"*.java 2>/dev/null; then c2=$((c2 + 1)); fi
done

# --- C3: ConfigBuilder.create() + setParentScreen + setTitle entry points
c3=0
c3_total=3
for m in "static ConfigBuilder create" "setParentScreen" "setTitle"; do
  if rg -q "$m" "$SRC/api/ConfigBuilder.java" 2>/dev/null; then c3=$((c3 + 1)); fi
done

# --- report ---
echo "DOC_METHODS_FOUND=$c1/$c1_total"
echo "DOC_SETTERS_FOUND=$c2/$c2_total"
echo "SCREEN_API_FOUND=$c3/$c3_total"

ok=1
[[ "$c1" -eq "$c1_total" ]] || ok=0        # all documented option methods present
[[ "$c2" -eq "$c2_total" ]] || ok=0        # all chain setters present
[[ "$c3" -eq "$c3_total" ]] || ok=0        # screen API complete

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:docs-conformant"
  exit 0
else
  echo "RESULT=fail:drift"
  exit 1
fi
