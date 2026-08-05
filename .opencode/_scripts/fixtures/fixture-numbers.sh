#!/usr/bin/env bash
# exports: main
# purity: pure
# depends-on: none
# ring: 0 (PURE) — stdout contract emitter for the wrapper
# fixture-numbers.sh — emits numeric sequences
# Shape: plain integers, one per line
for i in 1 4 9 16 25 36 49 64; do
  echo "$i"
done
exit 0
