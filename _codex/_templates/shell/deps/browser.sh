#!/usr/bin/env bash
# deps/browser.sh — shared shell dependency: Chromium launch primitives
# Sourced by start-browser.sh + start-browser-headless.sh. Resolves CHROME
# (latest playwright chromium binary) and PROFILE (latest MCP profile),
# exiting non-zero with a hint when either is missing; provides port_up
# {port} (CDP /json/version probe) and wait_port {port} {label} {log}
# (30×1s poll; prints UP when ready, ERROR on timeout).
set -uo pipefail

CHROME="$(ls -d ~/.cache/ms-playwright/chromium-*/chrome-linux64/chrome 2>/dev/null | sort -V | tail -1)"
[ -z "$CHROME" ] && { echo "ERROR chromium not found under ~/.cache/ms-playwright" >&2; exit 1; }
PROFILE="$(ls -dt ~/.cache/ms-playwright-mcp/mcp-chrome-* 2>/dev/null | head -1)"
[ -z "$PROFILE" ] && { echo "ERROR MCP profile not found under ~/.cache/ms-playwright-mcp" >&2; exit 1; }

port_up() {
  curl -s "http://127.0.0.1:$1/json/version" >/dev/null 2>&1
}

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
