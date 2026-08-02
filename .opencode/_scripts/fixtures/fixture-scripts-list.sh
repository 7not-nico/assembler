#!/usr/bin/env bash
# fixture-scripts-list.sh — runs real _scripts Go CLI `list` verb
# Shape: entity listing; probes list subcommand
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" list terms
exit $?
