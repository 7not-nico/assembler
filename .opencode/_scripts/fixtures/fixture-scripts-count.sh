#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _golib/bin/assembler-cli
# ring: 2 (LOCAL-READ) — runs a Go CLI verb through the toolchain
# fixture-scripts-count.sh — runs the real _scripts Go CLI `count` verb
# Shape: entity-type table; probes toolchain execution + tabular output
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" count
exit $?
