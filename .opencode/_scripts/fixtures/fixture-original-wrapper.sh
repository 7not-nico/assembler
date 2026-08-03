#!/usr/bin/env bash
# fixture-original-wrapper.sh — exercises bitacora-log.sh (trace-free default)
# Shape: KEY=value contract; asserts the default wrapper emits the full
# provenance header (15 metadata keys) with ZERO trace lines (no EXEC/PROGS/
# tracexec). Runs a command through it and inspects the log it writes.
# Always available — the default wrapper lives in the repo (no _sandbox dep).
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)" # repo root
ORIG="$ROOT/.opencode/_bitacora/bitacora-log.sh"
STDOUT_DIR="$ROOT/.opencode/_bitacora/task-stdout"

if [[ ! -x "$ORIG" ]]; then
	echo "ORIGINAL=absent"
	echo "RESULT=skip:none"
	exit 0
fi

NAME="fixture-original-wrapper-$$"
before="$(ls "$STDOUT_DIR" 2>/dev/null | wc -l)"

# Run a command with known output through the original wrapper
out="$(timeout 15 "$ORIG" "$NAME" --task "original-fixture" -- sh -c 'echo hello; echo errline >&2' 2>&1)"
rc=$?

# The log it wrote = newest file in task-stdout
log_file="$(ls -t "$STDOUT_DIR"/*"$NAME"*.log 2>/dev/null | head -1)"

echo "WRAPPER_RC=$rc"
echo "LOG_WRITTEN=$([[ -n "$log_file" ]] && echo yes || echo no)"

if [[ -z "$log_file" ]]; then
	echo "RESULT=fail:no-log"
	exit 1
fi

meta_keys="$(rg -c '^# (CMD|ENV|TOOLS|DATE|PID|DUR|exit|GIT|BRANCH|SESSION|CLI|ARGS|CWD): ' "$log_file")"
tail_keys="$(rg -c '^# (OUT_LINES|OUT_BYTES|ERR_LINES|SHA): ' "$log_file")"
trace_lines="$(rg -c '^# (EXEC|PROGS|EXEC_COUNT|TRACE_FILE) ' "$log_file" || true)"
has_task="$(rg -c '^# TASK: original-fixture' "$log_file")"
has_stdout="$(rg -c '^hello$' "$log_file")"
has_stderr="$(rg -c '^errline$' "$log_file")"
has_sha="$(rg -c '^# SHA: [0-9a-f]{64}$' "$log_file")"

echo "META_KEYS=$meta_keys"
echo "TAIL_KEYS=$tail_keys"
echo "TRACE_LINES=${trace_lines:-0}"
echo "TASK_KEY=$has_task"
echo "STDOUT_REPLAYED=$has_stdout"
echo "STDERR_REPLAYED=$has_stderr"
echo "SHA_VALID=$has_sha"

ok=1
[[ "$rc" -eq 0 ]] || ok=0
[[ "$meta_keys" -ge 13 ]] || ok=0       # full provenance header present
[[ "$tail_keys" -eq 4 ]] || ok=0        # OUT_LINES/OUT_BYTES/ERR_LINES/SHA
[[ "${trace_lines:-0}" -eq 0 ]] || ok=0 # trace-free: no EXEC/PROGS
[[ "$has_task" -ge 1 ]] || ok=0         # --task flag honored
[[ "$has_stdout" -ge 1 ]] || ok=0       # stdout replayed
[[ "$has_stderr" -ge 1 ]] || ok=0       # stderr replayed
[[ "$has_sha" -ge 1 ]] || ok=0          # valid sha256 anchor

if [[ $ok -eq 1 ]]; then
	echo "RESULT=pass:$meta_keys"
	exit 0
else
	echo "RESULT=fail:probe"
	exit 1
fi
