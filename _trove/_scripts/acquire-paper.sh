#!/usr/bin/env bash
# acquire-paper.sh — one-command paper acquisition (conductor)
# Usage: bash acquire-paper.sh {pdf-url-or-arxiv-id} {domain} {subdomain} [timeout]
# Accepts an arxiv id (converts to pdf URL) or any PDF URL. Pipeline:
#   fetch-paper.sh   → download via the shared browser (CDP 9222)
#   verify-paper.sh  → PDF magic + page count
#   prepare-paper.sh → slugify into {domain}/{subdomain}/
# Prints ACQUIRED=<path> on success. Exits non-zero on any step failure.
set -uo pipefail

ARG="${1:?pdf-url-or-arxiv-id required}"
DOMAIN="${2:?domain required}"
SUBDOMAIN="${3:?subdomain required}"
TIMEOUT="${4:-60}"
HERE="$(cd "$(dirname "$0")" && pwd)"

case "$ARG" in
  http*|https*) URL="$ARG" ;;
  *) URL="https://arxiv.org/pdf/$ARG" ;;
esac

OUT="$(bash "$HERE/fetch-paper.sh" "$URL" "$TIMEOUT" | tee /dev/stderr | sed -n 's/^SAVEDPATH=//p' | tail -1)"
if [ -z "$OUT" ] || [ ! -f "$OUT" ]; then
  echo "ERROR download failed — no file saved" >&2
  exit 1
fi

bash "$HERE/verify-paper.sh" "$OUT" || exit 1
PAPER="$(bash "$HERE/prepare-paper.sh" "$OUT" "$DOMAIN" "$SUBDOMAIN" | tee /dev/stderr | sed -n 's/^PAPER //p' | tail -1)"
if [ -z "$PAPER" ] || [ ! -f "$PAPER" ]; then
  echo "ERROR prepare failed — no paper produced" >&2
  exit 1
fi

echo "ACQUIRED $PAPER"
