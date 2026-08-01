#!/usr/bin/env bash
# start-browser.sh — launch the shared persistent Chromium (original MCP profile)
# Usage: bash start-browser.sh
# Launches one headed Chromium on the ORIGINAL MCP browser profile
# (~/.cache/ms-playwright-mcp/mcp-chrome-*) with a CDP port (9222). The
# @playwright/mcp server attaches via --cdp-endpoint; scripts connect via
# connectOverCDP. Extensions and cookies live in the original profile — no
# copies, no separate instances.
# Idempotent: if the browser (or its port) is already up, exits 0.
set -uo pipefail

CHROME="$(ls -d ~/.cache/ms-playwright/chromium-*/chrome-linux64/chrome 2>/dev/null | sort -V | tail -1)"
[ -z "$CHROME" ] && { echo "ERROR chromium not found under ~/.cache/ms-playwright" >&2; exit 1; }
PROFILE="$(ls -dt ~/.cache/ms-playwright-mcp/mcp-chrome-* 2>/dev/null | head -1)"
[ -z "$PROFILE" ] && { echo "ERROR MCP profile not found under ~/.cache/ms-playwright-mcp" >&2; exit 1; }
PORT="${1:-9222}"

if curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
  echo "ALREADY browser on port $PORT"
  exit 0
fi

# profile lock guard: one instance per profile. A second launch on a locked
# profile hangs on SingletonLock — fail fast with the holder's identity.
if [ -e "$PROFILE/SingletonLock" ]; then
  HOLDER="$(pgrep -af "remote-debugging-port" | grep -v "start-browser" | head -2)"
  echo "LOCK  profile in use by:" >&2
  echo "$HOLDER" >&2
  echo "      stop it first, clear Singleton*, then relaunch" >&2
  exit 1
fi

nohup "$CHROME" \
  --ozone-platform=wayland --ozone-platform-hint=wayland \
  --no-sandbox --disable-blink-features=AutomationControlled \
  --remote-debugging-port="$PORT" \
  --user-data-dir="$PROFILE" \
  about:blank >/tmp/opencode/shared-browser.log 2>&1 &

for i in $(seq 1 30); do
  if curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
    echo "UP   port=$PORT profile=$PROFILE"
    exit 0
  fi
  sleep 1
done
echo "ERROR browser did not open port $PORT — see /tmp/opencode/shared-browser.log" >&2
exit 1
