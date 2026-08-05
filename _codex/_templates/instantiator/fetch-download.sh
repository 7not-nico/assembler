#!/usr/bin/env bash
# fetch-download.sh — instantiator code: download a file via the SHARED browser
# Usage: bash fetch-download.sh {url} [timeout-seconds] [--out {dir}] [--selector {css}]
# Connects to the shared persistent Chromium (CDP 9222, start-browser.sh),
# opens the URL, clicks the first direct-download anchor (default
# a[href*="token="]), and saves the file with a slugified name into the
# output dir (default $ASSEMBLER/.opencode/.playwright-mcp/). Prints
# SAVEDPATH={path} as the last line. Cwd-independent.
set -uo pipefail

URL="${1:?url required}"
TIMEOUT="${2:-60}"
shift 2 2>/dev/null || shift 1
OUT=""
SEL='a[href*="token="]'
while [ "$#" -gt 0 ]; do
	case "$1" in
	--out)
		OUT="${2:-}"
		shift 2
		;;
	--selector)
		SEL="${2:-}"
		shift 2
		;;
	*) shift ;;
	esac
done

# shared deps — browser readiness (paths + CDP check + playwright-core)
. "$(dirname "$0")/deps/browser.sh"
PW_DIR="${OUT:-$ASSEMBLER/.opencode/.playwright-mcp}"
mkdir -p "$PW_DIR"

export PW_URL="$URL" PW_DIR="$PW_DIR" PW_PORT="$PORT" PW_TIMEOUT="$TIMEOUT" PW_SEL="$SEL" NODE_PATH="$PW_CORE/.."
node <<'EOF' 2>&1
const { chromium } = require('playwright-core')

const url = process.env.PW_URL
const pwDir = process.env.PW_DIR
const port = process.env.PW_PORT
const timeout = Number(process.env.PW_TIMEOUT) * 1000
const sel = process.env.PW_SEL

const slug = name => name.toLowerCase()
  .replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '')

;(async () => {
  const browser = await chromium.connectOverCDP('http://127.0.0.1:' + port)
  const ctx = browser.contexts()[0]
  if (!ctx) throw new Error('no default context on shared browser')
  const page = await ctx.newPage()

  console.log('NAV  ' + url)
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout })

  const link = page.locator(sel).first()
  await link.waitFor({ timeout })
  console.log('LINK ' + (await link.getAttribute('href')))

  const [download] = await Promise.all([
    page.waitForEvent('download', { timeout }),
    link.click(),
  ])
  const full = download.suggestedFilename()
  const dot = full.lastIndexOf('.')
  const ext = dot > 0 ? full.slice(dot) : ''
  const out = pwDir + '/' + slug(dot > 0 ? full.slice(0, dot) : full) + ext
  await download.saveAs(out)
  console.log('SAVE ' + out + ' (' + full + ')')
  console.log('SAVEDPATH=' + out)

  await page.close()
  await browser.close()
})().catch(e => { console.error('ERROR ' + e.message); process.exit(1) })
EOF
