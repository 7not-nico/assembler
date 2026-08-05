#!/usr/bin/env bash
# stop-process.sh — instantiator code: stop a process chain by exact binary name
# Usage: bash stop-process.sh {binary-name}
# Kills the exact-named process (pgrep -x) first — the chain's root — waits,
# sweeps straggler wrappers whose command line names the binary, verifies
# nothing survives. Anchors the primary kill on the exact name only, so the
# wrapper's own command line never matches. Result lines: STOPPED={1|0}.
set -uo pipefail

BIN="${1:?binary name required}"
[ -n "$BIN" ] || { echo "ERROR empty binary name" >&2; exit 1; }

PIDS="$(pgrep -x "$BIN" || true)"
if [ -z "$PIDS" ]; then
  echo "no $BIN running"
  echo "STOPPED=0"
  exit 0
fi

for p in $PIDS; do kill "$p" 2>/dev/null || true; done
sleep 1

# straggler sweep — wrappers whose command line carries the binary
pgrep -f "tracexec log -- .*$BIN" | xargs -r kill 2>/dev/null || true
pgrep -f "run-bitacora.*$BIN" | xargs -r kill 2>/dev/null || true
sleep 1

if pgrep -x "$BIN" >/dev/null; then
  echo "ERROR still running:" >&2
  pgrep -ax "$BIN" | head -3 >&2
  echo "STOPPED=0"
  exit 1
fi

echo "$BIN chain stopped"
echo "STOPPED=1"
