#!/usr/bin/env bash
# bitacora-log.sh — run a command and record its output in task-stdout
# Adapted from .opencode/_bitacora/bitacora-log.sh — full provenance
# header, NO tracexec dependency (trace-free baseline, same metadata keys).
# Usage: bash bitacora-log.sh {name} [--task T] [--scope S] [--out O] [--in f1,f2] -- {command} [args...]
# Header: CMD, ENV, TOOLS, DATE, PID | DUR, exit, GIT, BRANCH, SCOPE, SESSION, TASK, CLI, ARGS, OUT, IN, CWD
# Data:   stdout + stderr replay
# Tail:   OUT_LINES, OUT_BYTES, ERR_LINES, SHA, exit
# SESSION: $BITACORA_SESSION env when set; else run-local 8-hex id
set -uo pipefail

BITACORA="$(cd "$(dirname "$0")" && pwd)"
NAME="${1:?name required}"
shift

# probe — first line of `{bin} --version` (go uses `go version`), else (no version)
probe() {
  local bin="$1" v
  if ! command -v "$bin" >/dev/null 2>&1; then return 1; fi
  case "$bin" in
    go) v="$(timeout 2 "$bin" version 2>/dev/null | head -1 | tr -d '\n')" ;;
    *)  v="$(timeout 2 "$bin" --version 2>/dev/null | head -1 | tr -d '\n')" ;;
  esac
  case "$v" in
    *[0-9]*) echo "$v" ;;
    *) echo "(no version)" ;;
  esac
}

TASK=""
SCOPE=""
OUT=""
IN=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --task)  TASK="${2:-}";  shift 2 ;;
    --scope) SCOPE="${2:-}"; shift 2 ;;
    --out)   OUT="${2:-}";   shift 2 ;;
    --in)    IN="${2:-}";    shift 2 ;;
    --) shift; break ;;
    *) break ;;
  esac
done

if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

STDOUT_DIR="$BITACORA/task-stdout"
mkdir -p "$STDOUT_DIR"
LOG="$STDOUT_DIR/$(date +%Y%m%d-%H%M%S)-$NAME.log"

START="$(date +%s%N)"

# --- CMD / ARGS: full terminal string + trailing tokens ---
CMD="$(printf '%q ' "$@")"
if [ "$#" -gt 1 ]; then
  ARGS="$(printf '%q ' "${@:2}")"
else
  ARGS="(none)"
fi

# --- CLI: invoked program + version, probed safely ---
PROG="${1:-}"
CLI_VERSION="$(probe "$PROG")"
case "$PROG" in
  bash) CLI_VERSION="${BASH_VERSION:-unknown}" ;;
esac

# --- GIT: repo@commit, or local@commit, or (no repo) ---
GIT_REF=""
BRANCH=""
if git rev-parse --short HEAD >/dev/null 2>&1; then
  REPO="$(basename "$(git remote get-url origin 2>/dev/null || echo local)")"
  GIT_REF="${REPO%.git}@$(git rev-parse --short HEAD)"
  BRANCH="$(git branch --show-current 2>/dev/null || echo detached)"
else
  GIT_REF="(no repo)"
  BRANCH="(no repo)"
fi

# --- ENV: versions of common runtimes present ---
ENV_INFO=""
for t in bun node python3 ruby rustc go; do
  v="$(probe "$t")" || continue
  ENV_INFO="$ENV_INFO $t=${v}"
done
[ -n "$ENV_INFO" ] || ENV_INFO="(none)"

# --- TOOLS: versions of every binary the wrapper itself invokes ---
TOOLS_INFO=""
for t in git sha256sum date wc cat tee mktemp rm timeout tr head cut; do
  v="$(probe "$t")" || continue
  TOOLS_INFO="$TOOLS_INFO $t=${v}"
done
[ -n "$TOOLS_INFO" ] || TOOLS_INFO="(none)"

# --- SESSION / PID ---
SESSION="${BITACORA_SESSION:-$(date +%s%N | sha256sum | cut -c1-8)}"
PID=$$

# --- IN: sha256 of caller-listed input files ---
IN_SHA=""
if [ -n "$IN" ]; then
  IFS=',' read -ra INFILES <<< "$IN"
  for f in "${INFILES[@]}"; do
    if [ -f "$f" ]; then
      IN_SHA="$IN_SHA${f##*/}=$(sha256sum "$f" | cut -d' ' -f1) "
    else
      IN_SHA="$IN_SHA${f##*/}=missing "
    fi
  done
fi

# Header part 1: identity keys (pre-run)
{
  echo "# CMD: $CMD"
  echo "# ENV:$ENV_INFO"
  echo "# TOOLS:$TOOLS_INFO"
  echo "# DATE: $(date -Is)"
  echo "# PID: $PID"
} | tee "$LOG"

# Run the user command directly (trace-free baseline)
OUT_TMP="$(mktemp)"
ERR_TMP="$(mktemp)"
"$@" >"$OUT_TMP" 2>"$ERR_TMP"
STATUS=$?
OUT_LINES="$(wc -l < "$OUT_TMP" | tr -d ' ')"
OUT_BYTES="$(wc -c < "$OUT_TMP" | tr -d ' ')"
ERR_LINES="$(wc -l < "$ERR_TMP" | tr -d ' ')"
DUR="$(($(($(date +%s%N) - START)) / 1000000))ms"

# Header part 2: DUR, exit + context keys (post-run)
{
  echo "# DUR: $DUR"
  echo "# exit: $STATUS"
  echo "# GIT: $GIT_REF"
  echo "# BRANCH: $BRANCH"
  [ -n "$SCOPE" ] && echo "# SCOPE: $SCOPE"
  echo "# SESSION: $SESSION"
  [ -n "$TASK" ] && echo "# TASK: $TASK"
  echo "# CLI: ${PROG} ${CLI_VERSION}"
  echo "# ARGS: $ARGS"
  [ -n "$OUT" ] && echo "# OUT: $OUT"
  [ -n "$IN_SHA" ] && echo "# IN: ${IN_SHA% }"
  echo "# CWD: $(pwd)"
  echo "# --------------------"
} | tee -a "$LOG"

# Replay both streams into the log
cat "$OUT_TMP" | tee -a "$LOG"
cat "$ERR_TMP" >&2
cat "$ERR_TMP" >> "$LOG"
rm -f "$OUT_TMP" "$ERR_TMP"
# Metrics tail (no EXEC/PROGS — trace-free baseline)
echo "# OUT_LINES: $OUT_LINES" | tee -a "$LOG"
echo "# OUT_BYTES: $OUT_BYTES" | tee -a "$LOG"
echo "# ERR_LINES: $ERR_LINES" | tee -a "$LOG"
SHA="$(sed '/^# SHA:/,$d' "$LOG" 2>/dev/null | sha256sum | cut -d' ' -f1)"
echo "# SHA: $SHA" | tee -a "$LOG"
exit "$STATUS"
