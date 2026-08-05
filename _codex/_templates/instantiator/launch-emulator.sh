#!/usr/bin/env bash
# launch-emulator.sh — instantiator code: detach-launch an emulator and health-check
# Usage: bash launch-emulator.sh {binary} {rom} [--log {path}] [--env KEY=VALUE...] [--emu-arg {arg}...]
# Shared code instantiated projects use to boot an emulator detached (setsid
# + nohup — new session, survives script exit) and verify the process lives
# after a grace period. --env passes extra env vars (e.g. SDL_VIDEODRIVER=x11)
# before the binary; --emu-arg passes emulator flags before the ROM (e.g.
# -l 127 for mGBA's log-level). Result lines: LAUNCH=, RUN=pid=..., or FAIL.
set -uo pipefail

# shell/schema — the only home for hardcoded values; cite it, never hardcode
. "$(cd "$(dirname "$0")" && pwd)/schema/lookup.sh"

BIN="${1:?binary path required}"
ROM="${2:?rom path required}"
shift 2
LOG="$SCHEMA_LAUNCH_LOG"
ENVS=()
EMUARGS=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --log) LOG="${2:-$LOG}"; shift 2 ;;
    --env) ENVS+=("$2"); shift 2 ;;
    --emu-arg) EMUARGS+=("$2"); shift 2 ;;
    *) shift ;;
  esac
done

[ -f "$ROM" ] || { echo "ERROR no such ROM: $ROM" >&2; exit 1; }
[ -x "$BIN" ] || { echo "ERROR emulator not found: $BIN" >&2; exit 1; }

mkdir -p /tmp/opencode
file "$ROM"
echo "LAUNCH $BIN $ROM"
setsid nohup env "${ENVS[@]}" "$BIN" "${EMUARGS[@]}" "$ROM" >"$LOG" 2>&1 </dev/null &
PID=$!
disown "$PID" 2>/dev/null || true
sleep 2
if kill -0 "$PID" 2>/dev/null; then
  echo "RUN   pid=$PID log=$LOG"
else
  echo "FAIL  emulator exited early — crash or missing window"
  cat "$LOG"
  wait "$PID"
  exit 1
fi
