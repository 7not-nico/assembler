#!/usr/bin/env bash
# deps/browser.sh — instantiator dependency: browser readiness
# Sources deps/paths.sh (SHARED_BIN, CODEX), probes the shared Chromium via
# the shared portup Go binary, and verifies playwright-core exists. Sets:
# PORT, PW_CORE. Exits non-zero with a restart hint when the browser or
# playwright-core is missing. One responsibility: prove the browser stack
# is usable.
set -uo pipefail

# shellcheck source=paths.sh
. "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

PORT="${CDP_PORT:-9222}"
PW_CORE="$CODEX/_templates/node_modules/playwright-core"

if ! "$SHARED_BIN/portup" "$PORT"; then
	echo "ERROR shared browser not running — start it: bash $CODEX/_templates/shell/start-browser.sh" >&2
	exit 1
fi

if [ ! -d "$PW_CORE" ]; then
	echo "ERROR playwright-core missing at $PW_CORE" >&2
	exit 1
fi
