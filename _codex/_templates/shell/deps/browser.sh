#!/usr/bin/env bash
# deps/browser.sh — shell dependency: Chromium launch primitives
# Sources deps/paths.sh (SHARED_BIN); port_up delegates to the shared
# portup Go binary. CHROME/PROFILE discovery and wait_port stay local.
set -uo pipefail

# shellcheck source=paths.sh
. "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

CHROME="$(ls -d ~/.cache/ms-playwright/chromium-*/chrome-linux64/chrome 2>/dev/null | sort -V | tail -1)"
[ -z "$CHROME" ] && { echo "ERROR chromium not found under ~/.cache/ms-playwright" >&2; exit 1; }
PROFILE="$(ls -dt ~/.cache/ms-playwright-mcp/mcp-chrome-* 2>/dev/null | head -1)"
[ -z "$PROFILE" ] && { echo "ERROR MCP profile not found under ~/.cache/ms-playwright-mcp" >&2; exit 1; }

port_up() { "$SHARED_BIN/portup" "$1"; }

wait_port() {
  local port="$1" label="$2" log="$3"
  for i in $(seq 1 30); do
    if port_up "$port"; then
      echo "UP   ${label:+$label }port=$port profile=$PROFILE"
      exit 0
    fi
    sleep 1
  done
  echo "ERROR $label did not open port $port — see $log" >&2
  exit 1
}
