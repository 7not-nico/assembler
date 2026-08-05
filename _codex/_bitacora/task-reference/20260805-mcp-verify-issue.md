# MCP server issue — inst_verify extension gap

**Date:** 2026-08-05
**Project:** `_codex/_templates/mcp/mcp-instantiator/` — the MCP wrapper over the instantiator tools

## What happened

`inst_verify` (the MCP tool → `wrapper/verify-archive.sh` → `instantiator/verify-archive.sh`) fails to verify any ROM whose image extension is not in the hardcoded SNES default list. Hit three times in one session across two consoles.

## Evidence (all 2026-08-05, real downloads)

**Tetris DS** (`.nds`) — via MCP:
```
inst_verify tetris-ds-usa.zip → ERROR no image inside archive (expected .nds,dsi,bin)
```
The explicit `image_ext: "nds,dsi,bin"` was passed yet still failed — the arg routes through but matching breaks.

**Mega Man Zero 2** (`.gba`) — via MCP:
```
inst_verify mega-man-zero-2-usa.zip → ERROR no image inside archive (expected .gba,bin,agb)
```
The archive content was confirmed correct by 7z:
```
Mega Man Zero 2 (USA).gba  (8388608 B)
```

**Bare-image case** (`.nds`, no archive):
```
inst_verify tetris-ds-usa.nds → ERROR unrecognized archive type: Nintendo DS ROM image
```
The bare-image passthrough also misses `.nds`.

## Root cause

`instantiator/verify-archive.sh:13`:
```bash
EXTS="sfc smc iso cso"
```
The default extension list is **SNES/PSP-only**. Every other console (`gba`, `gb`, `gbc`, `nds`, `dsi`, `nes`, `gen`, `n64`...) fails the "exactly-one image" check unless the caller remembers the exact `--image-ext` value — and even then the `.nds`/`.gba` matching has a secondary bug (the archive listing path doesn't apply the passed list correctly for those extensions).

## Why it matters

- Every non-SNES acquisition through the MCP server ends in a false ERROR despite a valid download
- The workaround (7z listing manually) bypasses the tool — the verify step becomes dead weight
- The `mcp-rom-acquire` pipeline (which calls verify internally) inherits the gap

## Fix path

1. **Widen the default** — `EXTS="sfc smc iso cso gba gb gbc nds dsi nes gen bin"` (or detect from `file` output instead of extension)
2. **Fix the passthrough** — ensure `--image-ext` overrides apply to the archive-listing match, not just the filename check
3. **Add bare-image detection** — the `file` probe already identifies "Nintendo DS ROM image" / "Game Boy Advance ROM image" — accept those as valid without an extension list
4. **Re-test** — the three failures above must pass after the fix

## Open edges

- `inst_fetch`/`inst_acquire` unaffected (they don't extension-filter)
- The `inst_trace` 0-line case for mGBA is a *different* issue (mGBA emits nothing on success) — not part of this fix

## Todo state

- [x] Document the issue
- [ ] Widen `EXTS` default in verify-archive.sh
- [ ] Fix `--image-ext` passthrough for non-SNES archives
- [ ] Add bare-image detection via `file` probe
- [ ] Re-test tetris (.nds) + megaman-zero-2 (.gba) + yoshi (.sfc regression)
