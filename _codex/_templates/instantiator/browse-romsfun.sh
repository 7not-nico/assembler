#!/usr/bin/env bash
# browse-romsfun.sh — instantiator code: discover a game's download variants
# Usage: bash browse-romsfun.sh {game-name-or-slug} [--timeout {seconds}] [{console}]
# Shared code instantiated projects use to browse the romsfun catalog. Uses
# the SHARED browser (CDP 9222, start-browser.sh). Searches the given console
# section (default super-nintendo; e.g. playstation-portable), opens the
# first matching game page, follows Download ROM, and lists the variant
# table. Machine lines for the orchestrator:
#   GAME <url> | <title>        — each matching game
#   VARIANTS:                   — section header
#   N <url> | <name>            — numbered variant of the first match
set -uo pipefail

QUERY="${1:?game-name-or-slug required}"
shift
TIMEOUT="45"
CONSOLE="super-nintendo"
while [ "$#" -gt 0 ]; do
	case "$1" in
	--timeout)
		TIMEOUT="${2:-45}"
		shift 2
		;;
	--*)
		echo "ERROR unknown flag: $1" >&2
		exit 1
		;;
	*)
		CONSOLE="$1"
		shift
		;;
	esac
done
# shared deps — browser readiness (paths + CDP check + playwright-core)
. "$(dirname "$0")/deps/browser.sh"

export PW_QUERY="$QUERY" PW_PORT="$PORT" PW_TIMEOUT="$TIMEOUT" PW_CONSOLE="$CONSOLE" NODE_PATH="$PW_CORE/.."
node <<'EOF' 2>&1
const { chromium } = require('playwright-core')

const query = process.env.PW_QUERY
const port = process.env.PW_PORT
const timeout = Number(process.env.PW_TIMEOUT) * 1000
const platform = process.env.PW_CONSOLE
const term = encodeURIComponent(query.replace(/ /g, '+'))

;(async () => {
  const browser = await chromium.connectOverCDP('http://127.0.0.1:' + port)
  const ctx = browser.contexts()[0]
  if (!ctx) throw new Error('no default context on shared browser')
  const page = await ctx.newPage()

  const searchUrl = 'https://romsfun.com/roms/' + platform + '/?s=' + term
  console.log('SEARCH ' + searchUrl)
  await page.goto(searchUrl, { waitUntil: 'domcontentloaded', timeout })

  const games = await page.$$eval('a[href*="/roms/' + platform + '/"][href$=".html"]', as => {
    const seen = new Set()
    const out = []
    for (const a of as) {
      const t = a.textContent.trim()
      if (!t || seen.has(a.href)) continue
      seen.add(a.href)
      out.push([a.href, t])
    }
    return out
  })
  for (const [u, t] of games) console.log('GAME ' + u + ' | ' + t)
  if (!games.length) throw new Error('no game matches ' + query)

  const gameUrl = games[0][0]
  console.log('OPEN ' + gameUrl)
  await page.goto(gameUrl, { waitUntil: 'domcontentloaded', timeout })
  const dl = await page.$eval('a[href*="/download/"]', a => a.href).catch(() => null)
  if (!dl) throw new Error('no download page on ' + gameUrl)

  console.log('DL ' + dl)
  await page.goto(dl, { waitUntil: 'domcontentloaded', timeout })
  const variants = await page.$$eval('table a[href*="/download/"]', as => as.map(a => a.href + ' | ' + a.textContent.trim()))
  console.log('VARIANTS:')
  variants.forEach((v, i) => console.log((i + 1) + ' ' + v))

  await page.close()
  await browser.close()
})().catch(e => { console.error('ERROR ' + e.message); process.exit(1) })
EOF
