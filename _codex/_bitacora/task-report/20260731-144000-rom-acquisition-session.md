# snes9x ROM acquisition + tooling session

Timestamp: 2026-07-31 14:40 (updated 14:55)

## What was done

1. **Zelda: A Link to the Past acquired** — romsfun.com chain: game page → Download ROM → variant page (`/download/legend-of-zelda-the-a-link-to-the-past-7093/5`, USA No-Intro) → zip captured → verified (Zip, one `.sfc`, 1,048,576 B) → slugified to `roms/legend-of-zelda-the-a-link-to-the-past-usa.sfc`. `file`: Super NES ROM image, LoROM, 1024KB.
2. **SMW2+2 (hack) acquired via the shared browser** — `romsfun.com/download/smw22-139832/1`; download anchor on `sto.romsfast.com` (not `statics.romsfun.com`). Zip saved as `smw2-plus-2-complete.zip` (extension was lost in the first save — slug stripped the dot; fixed). Prepared to `roms/smw2-2-complete.sfc` (2,097,664 B, 2 MiB hack) and launched detached.
3. **Shared browser architecture** — one persistent Chromium on CDP port 9222 running the original MCP profile (`~/.cache/ms-playwright-mcp/mcp-chrome-3f2da58`, extensions + cookies). Scripts connect via `connectOverCDP`; `_templates/start-browser.sh` starts it. The shared instance is the single correct browser — MCP-launched (pipe) browsers cannot serve external scripts.
4. **Atomic scripts** — `scripts/` split into `fetch-rom.sh` (CDP download, `token=` anchor covering both CDNs), `verify-rom.sh` (file + unzip checks, warns on nonstandard size), `prepare-rom.sh` (extract → slugify → `roms/`), `launch-rom.sh` (setsid+nohup detach, persists after script exit, log `/tmp/opencode/snes9x-launch.log`), `playwright-fetch-rom.sh` (thin orchestrator composing the four).
5. **Precepts** — `precept/` created: `use-shared-browser.md`, `acquire-rom.md`, `run-atomic.md` (action-domain naming).
6. **AGENTS.md updated** — structure, shared browser section, acquisition flow, detached launch verification, task-stdout naming.
7. **Detached launch verified** — `setsid nohup` + `disown`: script exits, emulator stays (`pgrep -x snes9x` still alive). Emulator health: ALSA init lines, no joystick errors, window on `DISPLAY:0`.
8. **Upscale attempt, then undone** — WM window-resize (`hyprctl dispatch resizewindowpixel`, env-var driven `S9X_SCALE`) tested and reverted: it stretches the 256×224 framebuffer, not the internal render resolution. `launch-rom.sh` restored to clean detached launch; header documents that internal upscaling belongs to the emulator (`-v4`..`-v8` scalers).
9. **ROM library live** — 4 titles in `roms/`: `legend-of-zelda-the-a-link-to-the-past-usa.sfc`, `super-mario-world-usa.sfc`, `super-mario-kart-usa.sfc`, `smw2-2-complete.sfc`. Final run: Zelda, pid 233593.

## Decisions

- The MCP-launched browser (pipe) cannot serve external scripts; the shared CDP browser on the original profile is the single correct instance. Never launch new instances; never copy profiles.
- Download anchor matched by `a[href*="token="]` — domain-agnostic (statics.romsfun.com and sto.romsfast.com).
- All zips land in `$ASSEMBLER/.opencode/.playwright-mcp/`; the root `.playwright-mcp` was removed (9 stray artifacts consolidated).
- `opencode.json` playwright MCP: reverted `--cdp-endpoint` (rejected approach); kept `--output-dir .opencode/.playwright-mcp`. MCP server killed mid-session — browser tools unavailable this session; respawn on next session start.
- Hyprland config never modified — upscaling stays out of the WM (config grep clean, `hyprctl configerrors` clean).

## Errors found

- `pkill -f 'snes9x.*sfc'` self-matched the wrapper shell's own command line → killed the command silently. Fixed with `pkill -x snes9x`.
- Slug function stripped the `.zip` extension on save (`smw2-plus-2-complete-zip`). Fixed by preserving the extension in `fetch-rom.sh`.
- Script stall on SMW2+2: locator `statics.romsfun.com` never matched (`sto.romsfast.com` host). Fixed with `token=` locator.
- New-browser launches stalled on the profile `SingletonLock` while the MCP browser held it (start-browser.sh ran before killing the old instance).
- WM window resize does not change snes9x internal resolution — upscale via `hyprctl`/env var reverted after verification.

## Open edges

- MCP browser tools (browser_navigate/click) dead this session — server killed; respawns next session against the shared browser only if opencode.json uses `--cdp-endpoint`; current config keeps the server launching its own pipe browser. The script flow does not depend on MCP.
- `opencode.json` still carries `--output-dir .opencode/.playwright-mcp` — unverified until the server respawns.
- Internal upscaling (hq2x `-v8` etc.) not yet wired into `launch-rom.sh` — emulator scaler flags remain the correct path.

## Todo state

Zelda acquisition: all completed. Tooling + precepts + AGENTS.md: completed. Upscale experiment: completed + reverted. Report: written.
