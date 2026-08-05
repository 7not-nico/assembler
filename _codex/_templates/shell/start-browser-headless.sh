#!/usr/bin/env bash
# start-browser-headless.sh — launch a headless Chromium for scripted acquisition
# Usage: bash start-browser-headless.sh [port]
# Runs --headless=new on the ORIGINAL MCP profile (extensions + cookies),
# CDP port 9223 by default — distinct from the headed shared browser (9222).
# Connect with CDP_PORT=9223:  bash scripts/fetch-rom.sh {url} 45
# Idempotent: if the port is already up, exits 0.
# Discovery + readiness primitives live in deps/browser.sh.
set -uo pipefail

. "$(cd "$(dirname "$0")" && pwd)/deps/browser.sh"
# shell/schema — the only home for hardcoded values; cite it, never hardcode
. "$(cd "$(dirname "$0")" && pwd)/../instantiator/schema/lookup.sh"

PORT="${1:-$SCHEMA_CDP_PORT_HEADLESS}"

if port_up "$PORT"; then
  echo "ALREADY headless browser on port $PORT"
  exit 0
fi

# profile lock: the headed shared browser holds the original profile —
# one instance per profile. Stop it first or the launch aborts (SingletonLock).
if [ -e "$PROFILE/SingletonLock" ]; then
  if port_up "$SCHEMA_CDP_PORT_HEADED"; then
    echo "LOCK  headed browser holds the profile on $SCHEMA_CDP_PORT_HEADED — stop it first:" >&2
    echo "      pkill -f 'remote-debugging-port=$SCHEMA_CDP_PORT_HEADED'" >&2
    exit 1
  fi
  rm -f "$PROFILE/SingletonLock" "$PROFILE/SingletonSocket" "$PROFILE/SingletonCookie"
fi

nohup "$CHROME" \
  --headless=new \
  --ozone-platform=headless \
  --no-sandbox --disable-blink-features=AutomationControlled \
  --remote-debugging-port="$PORT" \
  --user-data-dir="$PROFILE" \
  about:blank >/tmp/opencode/headless-browser.log 2>&1 &

wait_port "$PORT" "headless browser" "/tmp/opencode/headless-browser.log"
