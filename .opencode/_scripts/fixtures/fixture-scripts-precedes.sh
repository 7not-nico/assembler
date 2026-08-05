#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _golib/bin/assembler-cli
# ring: 2 (LOCAL-READ) — runs a Go CLI verb through the toolchain
# fixture-scripts-precedes.sh — runs real _scripts Go CLI `check precedes` verb
# Shape: cycle detection; probes integrity check subcommand
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" check precedes
exit $?
