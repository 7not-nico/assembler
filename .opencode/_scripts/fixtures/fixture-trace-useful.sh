#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: tracexec, bitacora-log.sh
# ring: 4 (LOCAL-WRITE) — exercises the trace-enriched wrapper
# fixture-trace-useful.sh — runs trace-useful.sh against the buggy fixture
# Shape: KEY=value contract; asserts the useful-log metrics: real exec tree
# visible, PATH-scan ENOENT burst collapsed, exit status preserved.
# Graceful SKIP when the gitignored _sandbox/ is absent (fresh clone).
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"        # repo root
SB="$ROOT/_sandbox"
TRACER="$SB/trace-useful.sh"
BUGGY="$SB/buggy-script.sh"

if [[ ! -x "$TRACER" || ! -x "$BUGGY" ]]; then
  echo "SANDBOX=absent"
  echo "RESULT=skip:none"
  exit 0
fi

if [[ -n "${BITACORA_SELF_TRACED:-}" ]]; then
  # Nested under bitacora-log: tracer defers (ptrace cannot nest — EPERM).
  # Verify graceful defer: EXIT preserved, defer note emitted, no hang.
  out="$(timeout 10 "$TRACER" -- "$BUGGY" 2>&1)"
  rc=$?
  echo "MODE=deferred"
  echo "TRACER_RC=$rc"
  echo "EXIT=$(printf '%s\n' "$out" | sed -n 's/^EXIT=//p')"
  if [[ $rc -eq 0 && $(printf '%s\n' "$out" | rg -c 'NOTE: nested') -ge 1 ]]; then
    echo "RESULT=pass:deferred"
    exit 0
  fi
  echo "RESULT=fail:deferred"
  exit 1
fi

# Standalone: full useful trace — real exec tree, PATH scans collapsed.
out="$(timeout 10 "$TRACER" -- "$BUGGY" 2>&1)"
rc=$?

exec_events="$(printf '%s\n' "$out" | sed -n 's/^EXEC_EVENTS=//p')"
useful_events="$(printf '%s\n' "$out" | sed -n 's/^USEFUL_EVENTS=//p')"
scans="$(printf '%s\n' "$out" | sed -n 's/^COLLAPSED_SCANS=//p')"
fails="$(printf '%s\n' "$out" | sed -n 's/^FAILS=//p')"
exit_code="$(printf '%s\n' "$out" | sed -n 's/^EXIT=//p')"
tree_lines="$(printf '%s\n' "$out" | rg -c '^  [0-9]+ +[0-9]+ +[0-9]+ +[0-9]+ +.* (bash|sleep|ls) ' )"

echo "MODE=standalone"
echo "EXEC_EVENTS=$exec_events"
echo "USEFUL_EVENTS=$useful_events"
echo "COLLAPSED_SCANS=$scans"
echo "FAILS=$fails"
echo "EXIT=$exit_code"
echo "TREE_LINES=$tree_lines"
echo "TRACER_RC=$rc"

ok=1
[[ "$exec_events" -ge 10 ]] || ok=0       # raw stream present
[[ "$useful_events" -ge 3 ]] || ok=0      # real execs surfaced
[[ "$scans" -ge 1 ]] || ok=0              # PATH burst collapsed
[[ "$exit_code" == "0" ]] || ok=0         # buggy script masks with exit 0
[[ "$tree_lines" -ge 3 ]] || ok=0         # bash + sleep + ls visible

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$useful_events"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
