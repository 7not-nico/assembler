#!/usr/bin/env bash
# fixture-scripts-count.sh — runs the real _scripts Go CLI `count` verb
# Shape: entity-type table; probes toolchain execution + tabular output
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" count
exit $?
