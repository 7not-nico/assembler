#!/usr/bin/env bash
# browse-arxiv.sh — discover papers on arxiv (atomic discovery unit)
# Usage: bash browse-arxiv.sh {query} [--timeout {seconds}]
# Uses the SHARED browser (CDP 9222, start-browser.sh). Searches arxiv
# full-text search and lists the first page of matches. Machine lines for
# the orchestrator:
#   PAPER <abs-url> | <title> | <arxiv-id>
set -uo pipefail

QUERY="${1:?query required}"
TIMEOUT="${2:-45}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PORT="${CDP_PORT:-9222}"

if ! curl -s "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
  echo "ERROR shared browser not running — start it: bash start-browser.sh" >&2
  exit 1
fi

PW_CORE=""
for dir in "$HERE" "$(cd "$HERE/../_templates" && pwd)" "$(cd "$HERE/../.opencode" && pwd)"; do
  if [ -d "$dir/node_modules/playwright-core" ]; then PW_CORE="$dir/node_modules/playwright-core"; break; fi
done
[ -n "$PW_CORE" ] || { echo "ERROR playwright-core missing" >&2; exit 1; }

export PW_QUERY="$QUERY" PW_PORT="$PORT" PW_TIMEOUT="$TIMEOUT" NODE_PATH="$PW_CORE/.."
node <<'EOF' 2>&1
const { chromium } = require('playwright-core')

const query = process.env.PW_QUERY
const port = process.env.PW_PORT
const timeout = Number(process.env.PW_TIMEOUT) * 1000
const term = encodeURIComponent(query.replace(/ /g, '+'))

;(async () => {
  const browser = await chromium.connectOverCDP('http://127.0.0.1:' + port)
  const ctx = browser.contexts()[0]
  if (!ctx) throw new Error('no default context on shared browser')
  const page = await ctx.newPage()

  const searchUrl = 'https://arxiv.org/search/?query=' + term + '&searchtype=all'
  console.log('SEARCH ' + searchUrl)
  await page.goto(searchUrl, { waitUntil: 'domcontentloaded', timeout })

  const papers = await page.$$eval('li.arxiv-result', lis => lis.map(li => {
    const a = li.querySelector('p.list-title a, a[href*="/abs/"]')
    return a ? [a.href, a.textContent.trim().replace(/\s+/g, ' ')] : null
  }).filter(Boolean))

  for (const [u, t] of papers) {
    const id = (u.match(/\/abs\/([^?#]+)/) || [])[1] || ''
    console.log('PAPER ' + u + ' | ' + t + ' | ' + id)
  }
  if (!papers.length) throw new Error('no paper matches ' + query)

  await page.close().catch(() => {})
  process.exit(0) // shared browser — drop the CDP connection, never close it
})().catch(e => { console.error('ERROR ' + e.message); process.exit(1) })
EOF
