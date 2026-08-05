#!/usr/bin/env bash
# start-browser.sh — launch the shared persistent Chromium (original MCP profile)
# Usage: bash start-browser.sh
# Launches one headed Chromium on the ORIGINAL MCP browser profile
# (~/.cache/ms-playwright-mcp/mcp-chrome-*) with a CDP port (9222). The
# @playwright/mcp server attaches via --cdp-endpoint; scripts connect via
# connectOverCDP. Extensions and cookies live in the original profile — no
# copies, no separate instances.
# Idempotent: if the browser (or its port) is already up, exits 0.
# Discovery + readiness primitives live in deps/browser.sh.
set -uo pipefail

. "$(cd "$(dirname "$0")" && pwd)/deps/browser.sh"
# shell/schema — the only home for hardcoded values; cite it, never hardcode
. "$(cd "$(dirname "$0")" && pwd)/../instantiator/schema/lookup.sh"

PORT="${1:-$SCHEMA_CDP_PORT_HEADED}"

if port_up "$PORT"; then
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

wait_port "$PORT" "browser" "/tmp/opencode/shared-browser.log"
