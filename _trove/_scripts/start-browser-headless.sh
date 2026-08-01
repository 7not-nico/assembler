#!/usr/bin/env bash
# start-browser-headless.sh — launch a headless Chromium for scripted acquisition
# Usage: bash start-browser-headless.sh [port]
# Runs --headless=new on the ORIGINAL MCP profile (extensions + cookies),
# CDP port 9223 by default — distinct from the headed shared browser (9222).
# Connect with CDP_PORT=9223:  bash scripts/fetch-rom.sh {url} 45
# Idempotent: if the port is already up, exits 0.
set -uo pipefail

CHROME="$(ls -d ~/.cache/ms-playwright/chromium-*/chrome-linux64/chrome 2>/dev/null | sort -V | tail -1)"
[ -z "$CHROME" ] && { echo "ERROR chromium not found under ~/.cache/ms-playwright" >&2; exit 1; }
PROFILE="$(ls -dt ~/.cache/ms-playwright-mcp/mcp-chrome-* 2>/dev/null | head -1)"
[ -z "$PROFILE" ] && { echo "ERROR MCP profile not found under ~/.cache/ms-playwright-mcp" >&2; exit 1; }
PORT="${1:-9223}"

if curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
  echo "ALREADY headless browser on port $PORT"
  exit 0
fi

# profile lock: the headed shared browser (9222) holds the original profile —
# one instance per profile. Stop it first or the launch aborts (SingletonLock).
if [ -e "$PROFILE/SingletonLock" ]; then
  if curl -s "http://127.0.0.1:9222/json/version" >/dev/null 2>&1; then
    echo "LOCK  headed browser holds the profile on 9222 — stop it first:" >&2
    echo "      pkill -f 'remote-debugging-port=9222'" >&2
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

for i in $(seq 1 30); do
  if curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
    echo "UP   headless port=$PORT profile=$PROFILE"
    exit 0
  fi
  sleep 1
done
echo "ERROR headless browser did not open port $PORT — see /tmp/opencode/headless-browser.log" >&2
exit 1
