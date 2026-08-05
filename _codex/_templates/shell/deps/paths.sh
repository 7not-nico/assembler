#!/usr/bin/env bash
# deps/paths.sh — shell dependency: resolve _codex via the shared Go binary
# Walk-up locates _shared/bin/codexroot (canonical and dive copies both
# resolve); codex_root {caller-script-dir} sets CODEX from the binary
# output. Sets: SHARED_BIN, then CODEX on call.
set -uo pipefail

resolve_shared() {
  local d
  d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  while [ "$d" != "/" ]; do
    if [ -x "$d/_shared/bin/codexroot" ]; then
      SHARED_BIN="$d/_shared/bin"
      return 0
    fi
    d="$(dirname "$d")"
  done
  echo "ERROR _shared/bin/codexroot not found above deps" >&2
  exit 1
}
resolve_shared

codex_root() {
  CODEX="$("$SHARED_BIN/codexroot" "${1:?base dir required}")" || exit $?
}
