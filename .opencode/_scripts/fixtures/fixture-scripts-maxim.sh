#!/usr/bin/env bash
# fixture-scripts-maxim.sh — runs real _scripts Ruby r2-maxim-* analyzer
# Shape: maxim structural audit; probes r2 ring (REMOTE-WRITE)
cd "$(dirname "$0")/.."
ruby r2-seed-audit.rb
exit $?
