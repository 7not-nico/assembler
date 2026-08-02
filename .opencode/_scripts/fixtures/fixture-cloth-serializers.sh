#!/usr/bin/env bash
# fixture-cloth-serializers.sh — probes the cloth-config autoconfig serializers
# Shape: KEY=value contract; counts serializer implementations + supported
# formats (Gson, Jankson, Toml4j, Yaml, Partitioning). Graceful SKIP absent.
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"           # repo root
CLONE="$ROOT/_sandbox/cloth-config"

if [[ ! -d "$CLONE" ]]; then
  echo "CLOTH_CONFIG=absent"
  echo "RESULT=skip:none"
  exit 0
fi

SER="$CLONE/common/src/main/java/me/shedaniel/autoconfig/serializer"
AUTOCFG="$CLONE/common/src/main/java/me/shedaniel/autoconfig"

# --- pure probes ---
ser_files="$(find "$SER" -name '*.java' | wc -l)"
ser_interfaces="$(rg -l '^public interface ' "$SER" 2>/dev/null | wc -l)"
ser_impls="$(rg -l '^public class ' "$SER" 2>/dev/null | wc -l)"
formats="$(find "$SER" -name '*ConfigSerializer.java' | sed 's/.*\///; s/ConfigSerializer\.java//' | tr '\n' ',' | sed 's/^,//; s/,$//')"
autocfg_interfaces="$(rg -l '^public interface ' "$AUTOCFG" 2>/dev/null | wc -l)"

# --- report ---
echo "SERIALIZER_FILES=$ser_files"
echo "SERIALIZER_INTERFACES=$ser_interfaces"
echo "SERIALIZER_IMPLS=$ser_impls"
echo "SERIALIZER_FORMATS=${formats%,}"
echo "AUTOCONFIG_INTERFACES=$autocfg_interfaces"

ok=1
[[ "$ser_files" -ge 6 ]] || ok=0
[[ "$ser_interfaces" -ge 1 ]] || ok=0
[[ "$ser_impls" -ge 5 ]] || ok=0
[[ "$formats" == *"Gson"* && "$formats" == *"Yaml"* ]] || ok=0

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$ser_files"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
