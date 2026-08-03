#!/usr/bin/env bash
# fixture-trace-command.sh — exercises bitacora-log.sh --trace (enriched stream)
# Shape: KEY=value contract; asserts the --trace run records the exec-tree
# enriched stdout in the log: provenance header + tracexec exec lines + the
# command's own output. Graceful SKIP when tracexec is absent.
# Constraint: run STANDALONE — do not wrap in an outer --trace (ptrace cannot
# nest; one tracer). The inner tracexec then fails and EXEC_LINES reads 0.
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)" # repo root
WRAP="$ROOT/.opencode/_bitacora/bitacora-log.sh"
STDOUT_DIR="$ROOT/.opencode/_bitacora/task-stdout"

if ! command -v tracexec >/dev/null 2>&1; then
	echo "TRACEXEC=absent"
	echo "RESULT=skip:no-tracexec"
	exit 0
fi
if [[ ! -x "$WRAP" ]]; then
	echo "WRAPPER=absent"
	echo "RESULT=skip:none"
	exit 0
fi

NAME="fixture-trace-command-$$"

# Run a command with known output through the wrapper with --trace
out="$(timeout 20 "$WRAP" "$NAME" --trace -- sh -c 'echo hello; echo errline >&2' 2>&1)"
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
exec_lines="$(rg -c 'tracer>:' "$log_file" || true)"
has_stdout="$(rg -c '^hello$' "$log_file")"
has_stderr="$(rg -c '^errline$' "$log_file")"
has_sha="$(rg -c '^# SHA: [0-9a-f]{64}$' "$log_file")"

echo "META_KEYS=$meta_keys"
echo "TAIL_KEYS=$tail_keys"
echo "EXEC_LINES=${exec_lines:-0}"
echo "STDOUT_REPLAYED=$has_stdout"
echo "STDERR_REPLAYED=$has_stderr"
echo "SHA_VALID=$has_sha"

ok=1
[[ "$rc" -eq 0 ]] || ok=0
[[ "$meta_keys" -ge 13 ]] || ok=0      # full provenance header present
[[ "$tail_keys" -eq 4 ]] || ok=0       # OUT_LINES/OUT_BYTES/ERR_LINES/SHA
[[ "${exec_lines:-0}" -ge 1 ]] || ok=0 # tracexec exec tree present
[[ "$has_stdout" -ge 1 ]] || ok=0      # command stdout replayed
[[ "$has_stderr" -ge 1 ]] || ok=0      # command stderr replayed
[[ "$has_sha" -ge 1 ]] || ok=0         # valid sha256 anchor

if [[ $ok -eq 1 ]]; then
	echo "RESULT=pass:${exec_lines:-0}"
	exit 0
else
	echo "RESULT=fail:probe"
	exit 1
fi
