# snes9x acquisitions + verify probe hardening

Timestamp: 2026-07-31 17:50

## What was done

### Acquisitions (4 titles, library now 14)

| Game | Variant | Size | Notes |
|------|---------|------|-------|
| EarthBound Beginnings v1.2 | (hack) | 4,194,304 B | acquire-rom picker matched the hack before stock EarthBound — first-match limitation noted |
| Keeper | Japan | 524,288 B | SFC puzzle game; exposed probe offset-validation bug |
| Super Bomberman 5 | Japan (Psyklax T-En + Svambo) | 2,097,152 B | exposed probe glob-char bug; `[i]` internal-header ROM |
| ActRaiser | USA (Arcade) | 1,048,576 B | picker grabbed `(USA) (Arcade)` over plain `(USA)` — preference anchor fixed |

### Ruby launcher v2

Letter-menu flow: shows initial-letter buckets (`A: 1  F: 1...`), user types a letter, numbered ROMs of that letter, pick → launch. Direct paths preserved (`2`, `zelda -v0`, `-l f -v9`). Verified: `f` → FF VI → launch.

### verify-rom.sh probe hardening (3 bugs, same family)

1. **Space truncation** — `awk $4` collapsed spaced names (`Donkey`); fixed with `unzip -Z1` full names.
2. **Glob metacharacters** — member names with `[`/`]` broke `unzip -p` pattern matching (empty extract); fixed with bracket-free pattern `'*.sfc'` + temp-file probe.
3. **Offset garbage** — HiROM offset returned junk (`v`) blocking the LoROM title; fixed with candidate validation (≥4 letters) + offset fallback.

Verified: Bomberman 5 → `Hu SUPER BOMBERMAN 5`, Keeper → `KEEPER`, Plok → `PLOK`, EarthBound → `EARTH BOUND`.

## Open edges

- `acquire-rom.sh` uses the first game match — "EarthBound" returned the Beginnings hack first; a title-exactness tier is a future picker improvement.
- Size whitelist (512K/1M) warns on 2/3/4 MiB — informational.
- MCP browser tools still dead this session; script flow independent.

## Todo state

Acquisitions: 4 completed. Launcher v2: completed + verified. Probe hardening: completed + verified. Report: written.
