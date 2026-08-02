#!/usr/bin/env bash
# bitacora-log.sh — run a command and record its output in task-stdout
# ALWAYS-on single-pass tracing via tracexec (ptrace cannot nest — one tracer).
#   Outer pass: tracexec wraps the WHOLE wrapper → captures every exec:
#               wrapper probes (git, sha256sum, wc, date, ...) AND the user
#               command tree (pipes, subshells, children) → EXEC lines + PROGS.
#   Inner pass: runs the user command directly (no nested tracer).
# tracexec is REQUIRED; missing it is a hard error (no silent untraced runs).
# Usage: bash bitacora-log.sh {name} [--task T] [--scope S] [--out O] [--in f1,f2] -- {command} [args...]
# Header: CMD, ENV, TOOLS, DATE, PID | DUR, exit, GIT, BRANCH, SCOPE, SESSION, TASK, CLI, ARGS, OUT, IN, CWD
# Data:   stdout + stderr replay
# Tail:   OUT_LINES, OUT_BYTES, ERR_LINES, EXEC* (every exec'd command), PROGS, SHA, exit
# SESSION: $BITACORA_SESSION env when set; else run-local 8-hex id
set -uo pipefail

# ============ PASS 1 (outer): trace the whole wrapper ============
if [ -z "${BITACORA_SELF_TRACED:-}" ]; then
  if ! command -v tracexec >/dev/null 2>&1; then
    echo "bitacora-log: ERROR: tracexec required for ALWAYS-on tracing — install: sudo pacman -S tracexec" >&2
    exit 1
  fi
  BITACORA="$(cd "$(dirname "$0")" && pwd)"
  NAME_OUTER="${1:?name required}"
  LOG_OUTER="$BITACORA/task-stdout/$(date +%Y%m%d-%H%M%S)-$NAME_OUTER.log"
  SELF_TRACE="$(mktemp)"
  EXECS_INFO=()
  # --trace FORMAT: persist the full tracexec export (json|json-stream|perfetto)
  # for deep analysis (perfetto opens in Chrome trace viewer). Default: summary only.
  TRACE_FORMAT=""
  for a in "$@"; do
    if [ "$a" = "--trace" ]; then TRACE_FORMAT="next"; continue; fi
    if [ "$TRACE_FORMAT" = "next" ]; then TRACE_FORMAT="$a"; break; fi
  done
  case "$TRACE_FORMAT" in
    json|json-stream|perfetto) : ;;
    *) TRACE_FORMAT="" ;;
  esac
  COLLECT_ARGS="--format=json --successful-only"
  if [ -n "$TRACE_FORMAT" ]; then
    COLLECT_ARGS="--format=$TRACE_FORMAT --successful-only"
  fi
  # re-exec inner under ONE tracexec; the entire wrapper (probes + user command)
  # is captured. --successful-only drops failed PATH probes (ENOENT noise).
  BITACORA_SELF_TRACED=1 \
  BITACORA_LOG_FILE="$LOG_OUTER" \
    tracexec collect $COLLECT_ARGS -o "$SELF_TRACE" -- bash "$0" "$@"
  WRAPPER_STATUS=$?
  # Parse the trace: every exec event (deduped) + unique binaries for PROGS.
  # Persist the raw export for deep analysis when --trace given
  TRACE_SAVED=""
  if [ -n "$TRACE_FORMAT" ]; then
    TRACE_SAVED="${LOG_OUTER%.log}.trace.$TRACE_FORMAT"
    cp "$SELF_TRACE" "$TRACE_SAVED"
  fi
  # Summary keys parse only the plain json schema; perfetto is a binary
  # protobuf, json-stream is newline-delimited — emit an honest note instead.
  if [ "$TRACE_FORMAT" = "json" ] || [ -z "$TRACE_FORMAT" ]; then
    # Parse the trace (json format): every exec event (deduped) + unique binaries.
    readarray -t EXECS_INFO < <(python3 -c '
import json, sys
d = json.load(open(sys.argv[1]))
seen = set()
progs = set()
for ev in d.get("events", []):
    fn = ev.get("filename") or ""
    argv = ev.get("argv") or {}
    av = argv.get("value", []) if isinstance(argv, dict) else []
    args = " ".join(av) if av else fn
    key = str(ev.get("pid", "?")) + "|" + fn + "|" + args
    if key not in seen:
        seen.add(key)
        print("EXEC|" + key)
    if fn and fn.startswith("/"):
        progs.add(fn)
for p in sorted(progs):
    print("PROG|" + p)
' "$SELF_TRACE" 2>/dev/null)
  fi
  rm -f "$SELF_TRACE"
  if [ "${#EXECS_INFO[@]}" -gt 0 ]; then
    EXEC_LINES="$(printf '%s\n' "${EXECS_INFO[@]}" | rg '^EXEC\|' | sed 's/^EXEC|//')"
    PROG_PATHS="$(printf '%s\n' "${EXECS_INFO[@]}" | rg '^PROG\|' | sed 's/^PROG|//')"
    PROGS_INFO=""
    while IFS= read -r bin; do
      [ -n "$bin" ] || continue
      # per-tool version flag: go uses `go version`, everything else --version
      case "${bin##*/}" in
        go) v="$(timeout 2 "$bin" version 2>/dev/null | head -1 | tr -d '\n')" ;;
        *)  v="$(timeout 2 "$bin" --version 2>/dev/null | head -1 | tr -d '\n')" ;;
      esac
      case "$v" in
        *[0-9]*) : ;;
        *) v="(no --version)" ;;
      esac
      PROGS_INFO="$PROGS_INFO ${bin##*/}=${v}"
    done <<< "$PROG_PATHS"
  else
    EXEC_LINES=""
    PROGS_INFO="(summary unavailable for $TRACE_FORMAT — full export in TRACE_FILE)"
  fi
  {
    while IFS= read -r ex; do
      [ -n "$ex" ] && echo "# EXEC: $ex"
    done <<< "$EXEC_LINES"
    echo "# PROGS:$PROGS_INFO"
    if [ "${#EXECS_INFO[@]}" -gt 0 ]; then
      echo "# EXEC_COUNT: $(printf '%s\n' "${EXECS_INFO[@]}" | rg -c '^EXEC\|')"
    fi
    [ -n "$TRACE_SAVED" ] && echo "# TRACE_FILE: $TRACE_SAVED"
    SHA="$(sed '/^# SHA:/,$d' "$LOG_OUTER" 2>/dev/null | sha256sum | cut -d' ' -f1)"
    echo "# SHA: $SHA"
    echo "# exit: $WRAPPER_STATUS"
  } | tee -a "$LOG_OUTER"
  exit "$WRAPPER_STATUS"
fi

# ============ PASS 2 (inner): run the user command ============
LOG="${BITACORA_LOG_FILE:?LOG path from outer required}"

NAME="${1:?name required}"
shift

TASK=""
SCOPE=""
OUT=""
IN=""
TRACE_FLAG=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --task)  TASK="${2:-}";  shift 2 ;;
    --scope) SCOPE="${2:-}"; shift 2 ;;
    --out)   OUT="${2:-}";   shift 2 ;;
    --in)    IN="${2:-}";    shift 2 ;;
    --trace) TRACE_FLAG="${2:-}"; shift 2 ;;
    --) shift; break ;;
    *) break ;;
  esac
done

if [ "$#" -eq 0 ]; then echo "command required" >&2; exit 1; fi

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
CLI_VERSION=""
case "$PROG" in
  bash) CLI_VERSION="${BASH_VERSION:-unknown}" ;;
  *)
    if command -v "$PROG" >/dev/null 2>&1; then
      CLI_VERSION="$(timeout 2 "$PROG" --version 2>/dev/null | head -1 | tr -d '\n')"
      case "$CLI_VERSION" in
        *[0-9]*) : ;;
        *) CLI_VERSION="unknown" ;;
      esac
    else
      CLI_VERSION="unknown"
    fi
    ;;
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
  command -v "$t" >/dev/null 2>&1 || continue
  case "$t" in
    go) v="$(timeout 2 "$t" version 2>/dev/null | head -1 | tr -d '\n')" ;;
    *)  v="$(timeout 2 "$t" --version 2>/dev/null | head -1 | tr -d '\n')" ;;
  esac
  ENV_INFO="$ENV_INFO $t=${v:-?}"
done
[ -n "$ENV_INFO" ] || ENV_INFO="(none)"

# --- TOOLS: versions of every binary the wrapper itself invokes ---
TOOLS_INFO=""
for t in git sha256sum date wc cat tee mktemp rm timeout tr head cut; do
  command -v "$t" >/dev/null 2>&1 || continue
  v="$(timeout 2 "$t" --version 2>/dev/null | head -1 | tr -d '\n')"
  case "$v" in
    *[0-9]*) : ;;
    *) v="(no version flag)" ;;
  esac
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

# Run the user command directly (no nested tracer — outer tracexec already
# captures everything this process tree execs).
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
# Metrics tail; EXEC/PROGS/SHA/exit appended by the OUTER pass
echo "# OUT_LINES: $OUT_LINES" | tee -a "$LOG"
echo "# OUT_BYTES: $OUT_BYTES" | tee -a "$LOG"
echo "# ERR_LINES: $ERR_LINES" | tee -a "$LOG"
exit "$STATUS"
