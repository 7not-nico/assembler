#!/usr/bin/env bash
# fetch-paper.sh — download a PDF through the SHARED browser (CDP 9222)
# Usage: bash fetch-paper.sh {pdf-url} [timeout-seconds]
# Drives an HTTP request through the browser context (context.request) —
# carries the shared session's cookies, no download-event dependency
# (arxiv renders PDFs inline; the event never fires). Saves the PDF slugged
# into $TROVE/.opencode/.playwright-mcp/, prints SAVEDPATH=<path>.
# Fallback path when curl is blocked (ACM, ScienceDirect, CAPTCHA sites).
# curl remains the primary path (download-invariants.sh).
set -uo pipefail

URL="${1:?pdf-url required}"
TIMEOUT="${2:-60}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TROVE="$(cd "$HERE/.." && pwd)"
PW_DIR="$TROVE/.opencode/.playwright-mcp"
PORT="${CDP_PORT:-9222}"

mkdir -p "$PW_DIR"
if ! curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
  echo "ERROR shared browser not running — start it: bash start-browser.sh" >&2
  exit 1
fi

PW_CORE=""
for dir in "$HERE" "$(cd "$HERE/../_templates" && pwd)" "$(cd "$HERE/../.opencode" && pwd)"; do
  if [ -d "$dir/node_modules/playwright-core" ]; then PW_CORE="$dir/node_modules/playwright-core"; break; fi
done
[ -n "$PW_CORE" ] || { echo "ERROR playwright-core missing" >&2; exit 1; }

export PW_URL="$URL" PW_DIR="$PW_DIR" PW_PORT="$PORT" PW_TIMEOUT="$TIMEOUT" NODE_PATH="$PW_CORE/.."
node <<'EOF' 2>&1
const { chromium } = require('playwright-core')
const fs = require('fs')

const url = process.env.PW_URL
const pwDir = process.env.PW_DIR
const port = process.env.PW_PORT
const timeout = Number(process.env.PW_TIMEOUT) * 1000

const slug = name => name.toLowerCase()
  .replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '')

;(async () => {
  const browser = await chromium.connectOverCDP('http://127.0.0.1:' + port)
  const ctx = browser.contexts()[0]
  if (!ctx) throw new Error('no default context on shared browser')

  console.log('FETCH ' + url)
  const resp = await ctx.request.get(url, { timeout })
  if (!resp.ok()) throw new Error('HTTP ' + resp.status())
  const body = await resp.body()

  const cd = resp.headers()['content-disposition'] || ''
  const m = cd.match(/filename="?([^";]+)"?/)
  const full = m ? m[1] : url.split('/').pop().split('?')[0]
  const dot = full.lastIndexOf('.')
  const ext = dot > 0 ? full.slice(dot) : '.pdf'
  const out = pwDir + '/' + slug(dot > 0 ? full.slice(0, dot) : full) + ext

  fs.writeFileSync(out, body)
  console.log('SAVE ' + out + ' (' + full + ', ' + body.length + ' B)')
  console.log('SAVEDPATH=' + out)

  await browser.close()
})().catch(e => { console.error('ERROR ' + e.message); process.exit(1) })
EOF
