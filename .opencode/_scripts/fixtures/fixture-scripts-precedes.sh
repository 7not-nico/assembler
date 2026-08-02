#!/usr/bin/env bash
# fixture-scripts-precedes.sh — runs real _scripts Go CLI `check precedes` verb
# Shape: cycle detection; probes integrity check subcommand
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" check precedes
exit $?
