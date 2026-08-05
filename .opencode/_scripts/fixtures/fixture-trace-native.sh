#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: tracexec, bitacora-log.sh
# ring: 4 (LOCAL-WRITE) — exercises the trace-enriched wrapper
# fixture-trace-native.sh — runs trace-native.sh (native tracexec flags)
# Shape: KEY=value contract; asserts the native frontend surfaces the exec
# tree with decoded errno, interpreter, cwd, env/fd diffs — no python parsing.
# Graceful SKIP when the gitignored _sandbox/ is absent (fresh clone).
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"        # repo root
SB="$ROOT/_sandbox"
TRACER="$SB/trace-native.sh"
BUGGY="$SB/buggy-script.sh"

if [[ ! -x "$TRACER" || ! -x "$BUGGY" ]]; then
  echo "SANDBOX=absent"
  echo "RESULT=skip:none"
  exit 0
fi

if [[ -n "${BITACORA_SELF_TRACED:-}" ]]; then
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

# Standalone: native flags must surface interpreter + decoded errno + env diff
out="$(timeout 15 "$TRACER" --successful-only -- "$BUGGY" 2>&1)"
rc=$?

exit_code="$(printf '%s\n' "$out" | sed -n 's/^EXIT=//p')"
flags="$(printf '%s\n' "$out" | sed -n 's/^flags=//p')"
interp="$(printf '%s\n' "$out" | rg -c 'interpreter "/usr/bin/env bash"')"
sleep_line="$(printf '%s\n' "$out" | rg -c '"/usr/bin/sleep".*M"SHLVL"')"
cwd_lines="$(printf '%s\n' "$out" | rg -c 'at "/home/eddyr/assembler')"

echo "MODE=standalone"
echo "EXIT=$exit_code"
echo "FLAGS=$flags"
echo "INTERPRETER_SHOWN=$interp"
echo "SLEEP_ENV_DIFF=$sleep_line"
echo "CWD_LINES=$cwd_lines"
echo "TRACER_RC=$rc"

ok=1
[[ "$exit_code" == "0" ]] || ok=0
[[ "$interp" -ge 1 ]] || ok=0                    # --show-interpreter works
[[ "$sleep_line" -ge 1 ]] || ok=0                # --diff-env works (M"SHLVL")
[[ "$cwd_lines" -ge 1 ]] || ok=0                 # --show-cwd works
[[ "$flags" == *"--decode-errno"* ]] || ok=0     # --decode-errno passed

if [[ $ok -eq 1 ]]; then
  echo "RESULT=pass:$interp"
  exit 0
else
  echo "RESULT=fail:probe"
  exit 1
fi
