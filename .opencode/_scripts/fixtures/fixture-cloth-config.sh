#!/usr/bin/env bash
# fixture-cloth-config.sh — probes the _sandbox/cloth-config repo structure
# Shape: KEY=value contract; Java API-surface metrics for the multi-loader
# Gradle project (common/fabric/forge). Graceful SKIP when the gitignored
# _sandbox/ clone is absent (fresh clone).
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"           # repo root
CLONE="$ROOT/_sandbox/cloth-config"

if [[ ! -d "$CLONE" ]]; then
  echo "CLOTH_CONFIG=absent"
  echo "RESULT=skip:none"
  exit 0
fi

SRC="$CLONE/common/src/main/java"
CLOTH="$SRC/me/shedaniel/clothconfig2"
AUTOCONFIG="$SRC/me/shedaniel/autoconfig"

# --- pure probes (no side effects beyond reads) ---

commit="$(git -C "$CLONE" rev-parse --short HEAD 2>/dev/null)"
depth="$(git -C "$CLONE" rev-list --count HEAD 2>/dev/null)"

java_total="$(find "$CLONE" -name '*.java' | wc -l)"
common_java="$(find "$CLONE/common" -name '*.java' | wc -l)"
fabric_java="$(find "$CLONE/fabric" -name '*.java' 2>/dev/null | wc -l)"
forge_java="$(find "$CLONE/forge" -name '*.java' 2>/dev/null | wc -l)"

api_java="$(find "$CLOTH/api" -name '*.java' 2>/dev/null | wc -l)"
api_interfaces="$(rg -l '^public interface ' "$CLOTH/api" 2>/dev/null | wc -l)"
api_abstract="$(rg -l '^public abstract class ' "$CLOTH/api" 2>/dev/null | wc -l)"
builders="$(ls "$CLOTH/impl/builders"/*.java 2>/dev/null | wc -l)"
entries="$(ls "$CLOTH/gui/entries"/*.java 2>/dev/null | wc -l)"
animators="$(ls "$CLOTH/api/animator"/*.java 2>/dev/null | wc -l)"
serializers="$(ls "$AUTOCONFIG/serializer"/*.java 2>/dev/null | wc -l)"

# --- report ---

echo "COMMIT=$commit"
echo "DEPTH=$depth"
echo "JAVA_TOTAL=$java_total"
echo "JAVA_COMMON=$common_java"
echo "JAVA_FABRIC=$fabric_java"
echo "JAVA_FORGE=$forge_java"
echo "API_JAVA=$api_java"
echo "API_INTERFACES=$api_interfaces"
echo "API_ABSTRACT=$api_abstract"
echo "BUILDERS=$builders"
echo "ENTRIES=$entries"
echo "ANIMATORS=$animators"
echo "SERIALIZERS=$serializers"

ok=1
[[ "$commit" =~ ^[0-9a-f]{7}$ ]] || ok=0
[[ "$depth" -eq 1 ]] || ok=0
[[ "$java_total" -gt 100 ]] || ok=0
[[ "$api_interfaces" -gt "$api_abstract" ]] || ok=0
[[ "$builders" -gt 10 ]] || ok=0
[[ "$entries" -gt 10 ]] || ok=0
[[ "$serializers" -ge 5 ]] || ok=0

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$java_total"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
