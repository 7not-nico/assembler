#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: _golib/bin/assembler-cli
# ring: 2 (LOCAL-READ) — runs a Go CLI verb through the toolchain
# fixture-scripts-audit.sh — runs real _scripts Go CLI `audit` verb
# Shape: per-check pass/fail table; probes audit verb scoped to a type
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" audit patterns
exit $?
