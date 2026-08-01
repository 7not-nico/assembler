# snes9x late acquisitions (2) — Looney Tunes, All-Stars, Bubsy

Timestamp: 2026-07-31 20:50

## What was done

### Phantom 2040 removal (library 31 → 30)

User directive: remove. Both artifacts deleted — `roms/phantom-2040-usa-beta.sfc` and `.opencode/.playwright-mcp/phantom-2040-usa-beta.zip`. Library count references updated in dive AGENTS.md (step 7, change inventory) and prior reports' open edges.

### Acquisitions (3 new, library 30 → 33)

| Game | Variant | Size | Notes |
|------|---------|------|-------|
| Looney Tunes B-Ball (USA) | `/1` | 2,097,152 B | Sunsoft Warner Bros. basketball; verified `LOONEY TUNES B-BALL`; launched pid 419138 |
| Super Mario All-Stars (USA) | `/2` | 2,097,152 B | SMB3's SNES home (remastered SMB1/2/3 + Lost Levels); verified `SUPER MARIO ALL_STARS`; 8 KB SRAM; launched pid 421626 |
| Bubsy II (USA) | `/2` | 2,097,152 B | verified `BUBSY II`; `file` misdetects as `PGP compressed data (BZIP2)` — header-quirk class (cf. DKC as "Applesoft BASIC"); launched pid 424447 |

### Browser restart (second occurrence)

`browse-romsfun.sh` reported "shared browser not running" at 20:35. `start-browser.sh` idempotent restart brought CDP 9222 back (UP, same profile `mcp-chrome-3f2da58`). No data loss; acquisition proceeded. Second documented occurrence of browser-down mid-session — idempotent launcher absorbs it without incident.

## Open edges

- Bubsy in: Claws Encounters of the Furred Kind (original) available on request — user picked Bubsy II.
- MCP browser tools still unavailable; script flow independent.
- Gundam Wing title probe reads patched header (`DDDDD`) — cosmetic.

## Todo state

Acquisitions: 3 completed. Phantom removal: completed. Browser restart: documented. Report: written. Chain closure: AGENTS.md count + invariant instance note pending.
