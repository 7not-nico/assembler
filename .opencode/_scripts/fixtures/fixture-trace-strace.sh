#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: tracexec, bitacora-log.sh
# ring: 4 (LOCAL-WRITE) — exercises the trace-enriched wrapper
# fixture-trace-strace.sh — runs trace-strace.sh against the buggy fixture
# Shape: KEY=value contract; asserts syscall-level signal: per-process exits
# expose masked failures (127 command-not-found, 2 ls error) despite exit 0.
# Graceful SKIP when the gitignored _sandbox/ is absent (fresh clone).
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"        # repo root
SB="$ROOT/_sandbox"
TRACER="$SB/trace-strace.sh"
BUGGY="$SB/buggy-script.sh"

if [[ ! -x "$TRACER" || ! -x "$BUGGY" ]]; then
  echo "SANDBOX=absent"
  echo "RESULT=skip:none"
  exit 0
fi

if [[ -n "${BITACORA_SELF_TRACED:-}" ]]; then
  # Nested under bitacora-log: strace defers (ptrace cannot nest — EPERM).
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

# Standalone: full syscall trace — masked failures must surface.
out="$(timeout 15 "$TRACER" -- "$BUGGY" 2>&1)"
rc=$?

pids="$(printf '%s\n' "$out" | sed -n 's/^PIDS=//p')"
failed="$(printf '%s\n' "$out" | sed -n 's/^FAILED=//p')"
exit_code="$(printf '%s\n' "$out" | sed -n 's/^EXIT=//p')"
exit127="$(printf '%s\n' "$out" | rg -c 'exit=127.*command not found')"
exit2="$(printf '%s\n' "$out" | rg -c 'exit=2.*FAIL ls /nonexistent-dir')"
scans="$(printf '%s\n' "$out" | rg -c 'PATH scans \(collapsed')"

echo "MODE=standalone"
echo "PIDS=$pids"
echo "FAILED=$failed"
echo "EXIT=$exit_code"
echo "EXIT127_LABELED=$exit127"
echo "EXIT2_LS=$exit2"
echo "PATH_SCANS_COLLAPSED=$scans"
echo "TRACER_RC=$rc"

ok=1
[[ "$pids" -ge 3 ]] || ok=0              # parent + sleep + 2 failing children
[[ "$failed" -ge 1 ]] || ok=0            # errno failures present
[[ "$exit_code" == "0" ]] || ok=0        # script masks with exit 0
[[ "$exit127" -ge 1 ]] || ok=0           # command-not-found labeled
[[ "$exit2" -ge 1 ]] || ok=0             # ls /nonexistent-dir surfaced
[[ "$scans" -ge 1 ]] || ok=0             # PATH bursts collapsed

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$pids"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
