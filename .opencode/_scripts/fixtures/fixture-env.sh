#!/usr/bin/env bash
# exports: main
# purity: pure
# depends-on: none
# ring: 0 (PURE) — stdout contract emitter for the wrapper
# fixture-env.sh — prints environment variables
# Shape: KEY=value pairs
echo "HOME=$HOME"
echo "USER=$(whoami)"
echo "SHELL=$SHELL"
exit 0
