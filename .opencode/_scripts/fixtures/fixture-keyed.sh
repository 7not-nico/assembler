#!/usr/bin/env bash
# exports: main
# purity: pure
# depends-on: none
# ring: 0 (PURE) — stdout contract emitter for the wrapper
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
