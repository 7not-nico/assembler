#!/usr/bin/env bash
# fixture-scripts-rings.sh — runs real _scripts Go CLI `rings` verb
# Shape: ring topology; probes topology output
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" rings
exit $?
