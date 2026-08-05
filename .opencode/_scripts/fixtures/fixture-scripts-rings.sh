#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _golib/bin/assembler-cli
# ring: 2 (LOCAL-READ) — runs a Go CLI verb through the toolchain
# fixture-scripts-rings.sh — runs real _scripts Go CLI `rings` verb
# Shape: ring topology; probes topology output
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" rings
exit $?
