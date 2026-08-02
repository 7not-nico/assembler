#!/usr/bin/env bash
# fixture-args.sh — echoes its arguments back, counted
# Probes: ARGS parsing, CMD quoting
usage() { echo "usage: fixture-args.sh [--flag VALUE]..."; exit 1; }
echo "argc=$#"
echo "args=$*"
exit 0
