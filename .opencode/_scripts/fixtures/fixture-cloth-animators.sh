#!/usr/bin/env bash
# fixture-cloth-animators.sh — probes the cloth-config animator API layer
# Shape: KEY=value contract; code-level metrics on the animation/value
# provider hierarchy (api/animator). Graceful SKIP when _sandbox/ absent.
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"           # repo root
CLONE="$ROOT/_sandbox/cloth-config"

if [[ ! -d "$CLONE" ]]; then
  echo "CLOTH_CONFIG=absent"
  echo "RESULT=skip:none"
  exit 0
fi

ANIM="$CLONE/common/src/main/java/me/shedaniel/clothconfig2/api/animator"

# --- pure probes ---
anim_files="$(find "$ANIM" -name '*.java' | wc -l)"
anim_interfaces="$(rg -l '^public interface ' "$ANIM" 2>/dev/null | wc -l)"
anim_abstract="$(rg -l '^public abstract class ' "$ANIM" 2>/dev/null | wc -l)"
anim_concrete="$(rg -l '^public class ' "$ANIM" 2>/dev/null | wc -l)"
animator_ifs="$(rg -l 'Animator' "$ANIM" 2>/dev/null | wc -l)"

# --- report ---
echo "ANIMATOR_FILES=$anim_files"
echo "ANIMATOR_INTERFACES=$anim_interfaces"
echo "ANIMATOR_ABSTRACT=$anim_abstract"
echo "ANIMATOR_CONCRETE=$anim_concrete"
echo "ANIMATOR_NAMED=$animator_ifs"

ok=1
[[ "$anim_files" -ge 10 ]] || ok=0
[[ "$anim_interfaces" -ge 2 ]] || ok=0
[[ "$animator_ifs" -ge 8 ]] || ok=0

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$anim_files"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
