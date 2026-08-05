#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _golib/bin/assembler-cli
# ring: 2 (LOCAL-READ) — runs a Go CLI verb through the toolchain
# fixture-scripts-list.sh — runs real _scripts Go CLI `list` verb
# Shape: entity listing; probes list subcommand
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" list terms
exit $?
