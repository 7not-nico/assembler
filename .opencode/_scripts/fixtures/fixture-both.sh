#!/usr/bin/env bash
# fixture-both.sh — interleaves stdout and stderr
# Shape: mixed streams, probes ERR_LINES split
echo "line-1-out"
echo "line-2-err" >&2
echo "line-3-out"
echo "line-4-err" >&2
echo "line-5-out"
exit 0
