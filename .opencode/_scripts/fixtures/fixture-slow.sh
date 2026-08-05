#!/usr/bin/env bash
# exports: main
# purity: pure
# depends-on: none
# ring: 0 (PURE) — stdout contract emitter for the wrapper
# fixture-slow.sh — sleeps, probes DUR in ms
# Shape: delayed single line
echo "starting slow work"
sleep 2
echo "finished"
exit 0
