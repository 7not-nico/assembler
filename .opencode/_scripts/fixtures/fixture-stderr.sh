#!/usr/bin/env bash
# exports: main
# purity: pure
# depends-on: none
# ring: 0 (PURE) — stdout contract emitter for the wrapper
# fixture-stderr.sh — emits stdout + stderr, exits non-zero
# Probes: ERR_LINES > 0, exit != 0
echo "begin work"
echo "warning: deprecation" >&2
echo "still going"
echo "fatal: something broke" >&2
echo "done"
exit 2
