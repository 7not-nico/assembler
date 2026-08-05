#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _golib/bin/assembler-cli
# ring: 2 (LOCAL-READ) — runs a Go CLI verb through the toolchain
# fixture-scripts-idmatch.sh — runs the real _scripts Go CLI `check id-match`
# Shape: pass/fail audit lines; probes validation output
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" check id-match
exit $?
