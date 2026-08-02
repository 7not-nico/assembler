#!/usr/bin/env bash
# fixture-scripts-audit.sh — runs real _scripts Go CLI `audit` verb
# Shape: per-check pass/fail table; probes audit verb scoped to a type
"$(cd "$(dirname "$0")/.." && pwd)/_golib/bin/assembler-cli" audit patterns
exit $?
