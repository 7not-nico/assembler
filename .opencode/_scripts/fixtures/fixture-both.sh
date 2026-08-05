#!/usr/bin/env bash
# exports: main
# purity: pure
# depends-on: none
# ring: 0 (PURE) — stdout contract emitter for the wrapper
# fixture-both.sh — interleaves stdout and stderr
# Shape: mixed streams, probes ERR_LINES split
echo "line-1-out"
echo "line-2-err" >&2
echo "line-3-out"
echo "line-4-err" >&2
echo "line-5-out"
exit 0
