# Precedence chain run — layer walk + library reconciliation

**Date:** 2026-07-31 22:22 local
**Status:** complete — chain walked, layers updated as required, count discrepancy resolved

## Chain run verdicts

| Layer | Verdict | Action |
|-------|---------|--------|
| `mcp/` | conductor + MCP servers worked for all 4 acquisitions | — |
| `invariant/` | all 8 held; Chrono Trigger `data` verdict didn't flip integrity (probe = authority) | no new invariant (mechanism → precept/procedure) |
| `scripts/` | no change needed | — |
| `_bitacora/` | todos + reports for 4 acquisitions + chain edit complete | this report + reconciliation |
| `precept/` | gap: ExHiROM misdetection undocumented | **updated** `acquire-rom.md` |
| `backup/` | no source edits | — |
| `study/` | no architecture change | — |
| `fixture/` | no scaler change | — |
| `pattern/` | no new morphism (mechanism detail, not structure) | — |
| `procedure/` | pipeline handled ExHiROM; doctrine lives in precept | — |

## Updates applied

1. **`precept/acquire-rom.md`** — verification clause extended: `file` misdetects HiROMs ("Applesoft BASIC") **and** expanded ExHiROM maps ("data", e.g. 6 MiB Chrono Trigger Enhansa); the title probe decides, never the file verdict.
2. **AGENTS.md item 4** — size classes extended to 2/3/4/6 MiB, ExHiROM misdetection documented, probe authority stated.
3. **AGENTS.md item 7** — library count corrected to **40 ROMs**.
4. **AGENTS.md inventory `roms/` row** — appended Ninja Warriors, Pop'n TwinBee EU, UN Squadron, Chrono Trigger Enhansa + reconciliation note (10 recovered titles).
5. **4 session reports** — correction notes appended (inherited stale counts; true 36→37→38→39→40).

## Library reconciliation — 10 unrecorded acquisitions

Pre-session directory held 36 `.sfc`; recorded trajectory ended at 34 (Pocky & Rocky). Zip timeline (41 zips − 1 SMW re-download dup − Phantom deleted) = 40 unique acquisitions = 40 ROMs. Ten titles had zero report coverage:

| Title | Zip time |
|-------|----------|
| Micro Machines (USA) | 18:18 |
| Micro Machines 2 Turbo Tournament (Europe) | 18:24 |
| Super Off-Road (USA) | 18:28 |
| Super Bomberman 4 (Japan T-En Svambo) | 18:33 |
| Mega Man X (USA) | 18:35 |
| Mega Man X2 (USA) | 18:35 |
| Mega Man X3 (USA) | 18:36 |
| Ogre Battle: March of the Black Queen (USA) | 18:40 |
| Sunset Riders (USA) | 20:57 |
| Arkanoid: Doh It Again (USA) | 21:07 |

**Drift causes:** 165500 reported "12 titles" at actual 13 (9 rows listed, claimed 10); ActRaiser double-counted (165500 + 175000); 191000's "26 → 31" never documented the 18:18–18:42 batch of 8; 205000's "30 → 33" missed Sunset Riders + Arkanoid; my session's reports inherited the stale count. The zip list is ground truth — every zip = one prepare = one ROM, each timestamped.

## Open edge

The 10 recovered titles have zips + ROMs + launches but no per-title acquisition reports from their sessions. Retroactive fabrication of those records is inappropriate; this reconciliation report is the honest record of the gap. Future sessions count from the zip list, not the AGENTS.md figure.

## Recovery verification (2026-07-31 22:30)

Content evidence probed directly from the 10 recovered ROMs — title at `0x7FC0` (LoROM), ≥4 letters, full alphabet (lowercase headers are a known class, cf. Pop'n TwinBee "twinbee"):

| ROM | Size | Title probe | Class |
|-----|------|-------------|-------|
| micro-machines-usa.sfc | 524,288 | `MICRO MACHINES` | standard |
| micro-machines-2-turbo-tournament-europe.sfc | 1,048,576 | `MICRO MACHINES 2` | standard |
| super-off-road-usa.sfc | 524,288 | `SUPER OFFROAD` | standard |
| super-bomberman-4-japan-t-en-by-svambo-v1-0.sfc | 2,097,152 | `b8R8B` | patched-header (Svambo T-En), cf. Gundam Wing `DDDDD` |
| mega-man-x-usa.sfc | 1,572,864 | `MEGAMAN X` | standard 12 Mbit |
| mega-man-x2-usa.sfc | 1,572,864 | `MEGAMAN X2` | standard 12 Mbit |
| mega-man-x3-usa.sfc | 2,097,152 | `MEGAMAN X3` | standard 16 Mbit |
| ogre-battle-the-march-of-the-black-queen-usa.sfc | 1,572,864 | `Ogre Battle USA` | lowercase header |
| sunset-riders-usa.sfc | 1,048,576 | `sunset riders` | lowercase header |
| arkanoid-doh-it-again-usa.sfc | 524,288 | `ARKANOID DOH IT AGAIN` | standard |

All 10 pass the title-region probe. No integrity anomalies; the unrecorded-acquisition gap is content-wise sound. Probe lesson: filters must accept `a-z` (lowercase headers exist); the precept's ≥4-letter validation already does.
