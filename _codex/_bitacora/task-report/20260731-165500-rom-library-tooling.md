# snes9x ROM library expansion + tooling

Timestamp: 2026-07-31 16:55

## What was done

### ROM acquisitions (10 new titles, all via the atomic pipeline)

| Game | Variant | Size | Notes |
|------|---------|------|-------|
| Terranigma | Europe | 4,194,304 B | first HiROM; `TERRANIGMA P` |
| Plok | USA | 1,048,576 B | LoROM FastROM |
| Donkey Kong Country | USA v1.0 | 4,194,304 B | `file` misdetected as Applesoft BASIC (HiROM quirk); header verified |
| Super Metroid | Japan/USA (En,Ja) | 3,145,728 B | the earlier stalled test, completed |
| FF VI | USA Woolsey Uncensored v3.06 | 4,194,304 B | `FINAL FANTASY 3` label; translation-path CDN |
| Super Tetris 3 | Japan (En) | 1,048,576 B | |
| Lethal Weapon | USA | 1,048,576 B | header typo `LETHAL WEPON` (genuine No-Intro) |
| Jelly Boy | Europe | 1,048,576 B | no US release |
| ActRaiser | USA (Arcade) | 1,048,576 B | picker preference bug caught: grabbed `(USA) (Arcade)` over plain `(USA)` — fixed |

Library: 12 titles.

### Tooling expansion

- `scripts/browse-romsfun.sh` — atomic discovery unit: search → game pages → download page → variant table (`GAME`/`DL`/`VARIANTS:` machine lines).
- `scripts/acquire-rom.sh` — top-level conductor: browse → preference-cascade pick (No-Intro → plain USA → any USA → first) → `playwright-fetch-rom.sh`. One command: `acquire-rom.sh {game}`.
- `scripts/verify-rom.sh` — SNES title-region probe (`0xFFC0` HiROM / `0x7FC0` LoROM) via `unzip -p | dd | tr`. Fixed latent `awk $4` space-truncation bug (`unzip -Z1` full-name mode).

### Knowledge + templates

- 4 new patterns: conductor-chain, preference-cascade, in-archive-probe, whitespace-field-parse.
- 4 new procedures: compose-conductor-chain, build-preference-cascade, probe-archive-region, parse-name-safe.
- `_templates/`: created `pattern-template.md`, `atomic-script-template.sh`; updated `copy-templates.sh` (copies codex dive files: pattern-template, atomic-script-template, precedence-chain, start-browser, run-logged, slugify) and `_templates/AGENTS.md` inventory.

## Errors found

- **`awk $4` truncation** — filename column with spaces collapsed (`Donkey`); `unzip -p` then silently found nothing → header probe empty on valid ROMs. Fixed with `unzip -Z1`.
- **Picker preference bug** — `grep '(usa)'` matched `(USA) (Arcade)` before plain `(USA)`. Fixed with `\(usa\)[^()]*$` anchor tier.
- **HiROM `file` misdetection** — `Applesoft BASIC` on DKC; the title-region probe is the reliable gate (snes9x's own loader passed).

## Open edges

- `verify-rom.sh` size whitelist (512K/1M) warns on 2/3/4 MiB — informational only; consider extending the whitelist.
- Hi-res SNES modes × HQ3X/HQ4X untested (2048×1792 at 4×).
- xBRZ (6×) + sharp-bilinear unwired.
- MCP browser tools still dead (server killed mid-session); script flow independent.

## Todo state

Acquisitions: 10 completed. Tooling: browse/acquire/verify — completed + verified. Patterns/procedures/templates: completed + copy-templates verified. Report: written.
