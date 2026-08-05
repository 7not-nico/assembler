#!/usr/bin/env bash
# deps/browser.sh — shared instantiator dependency: browser readiness
# Sourced by browser-backed instantiator tools
# (`. "$(dirname "$0")/deps/browser.sh"`). Sources deps/paths.sh, then checks
# the shared Chromium (CDP $PORT, default 9222) answers and playwright-core
# exists. Sets: PORT, PW_CORE. Exits non-zero with a restart hint when the
# browser or playwright-core is missing. One responsibility: prove the
# browser stack is usable.
set -uo pipefail

# shellcheck source=deps/paths.sh
. "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

PORT="${CDP_PORT:-9222}"
PW_CORE="$CODEX/_templates/node_modules/playwright-core"

if ! curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
	echo "ERROR shared browser not running — start it: bash $CODEX/_templates/shell/start-browser.sh" >&2
	exit 1
fi

if [ ! -d "$PW_CORE" ]; then
	echo "ERROR playwright-core missing at $PW_CORE" >&2
	exit 1
fi
