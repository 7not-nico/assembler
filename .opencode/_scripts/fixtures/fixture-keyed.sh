#!/usr/bin/env bash
# fixture-keyed.sh — emits a machine contract per structure-stdout
# Probes: OUT_LINES/OUT_BYTES, keyed-line extraction, IN hashing
KEY=${1:-default}
COUNT=0
for i in 1 2 3 4 5; do
  echo "item $i"
  COUNT=$((COUNT + 1))
done
echo "RESULT=$KEY:$COUNT"
exit 0
