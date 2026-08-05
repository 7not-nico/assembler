# MCP tool suite — reference

**Layer:** docs/
**Project:** `_codex/_templates/` — the codex toolchain

## The MCP server

`mcp/mcp-instantiator/` — MCP wrapper exposing the 8 instantiator flows as agent tools. Registered in `opencode.json` as `mcp-instantiator` (local, `bun run index.ts`). Every tool delegates: MCP → `wrapper/{tool}.sh` (resolves `_codex`) → `instantiator/{tool}.sh` (canonical). Keyed result lines pass through; failures surface as `ERROR` text + non-zero exit.

## The 8 tools

| Tool | Wrapper → Canonical | Result lines |
|---|---|---|
| `inst_acquire` | acquire-game.sh → instantiator/acquire-game.sh | `IMAGE=`, `SIZE=`, `STATUS=` |
| `inst_browse` | browse-romsfun.sh → instantiator/browse-romsfun.sh | `SEARCH`, `GAME`, `VARIANTS:` |
| `inst_build` | build-cmake.sh → instantiator/build-cmake.sh | `BUILD=pass`, `BINARY=`, `SIZE=` |
| `inst_fetch` | fetch-download.sh → instantiator/fetch-download.sh | `SAVEDPATH=` |
| `inst_launch` | launch-emulator.sh → instantiator/launch-emulator.sh | `LAUNCH=`, `RUN=pid=` |
| `inst_stop` | stop-process.sh → instantiator/stop-process.sh | `STOPPED=` |
| `inst_trace` | trace-evidence.sh → instantiator/trace-evidence.sh | `TRACE=`, `LINES=`, `EVIDENCE=` |
| `inst_verify` | verify-archive.sh → instantiator/verify-archive.sh | `OK=`, `IMAGE=`, `SIZE=` |

## Multi-console support (2026-08-05)

`inst_verify`'s extension handling was widened from SNES/PSP-only to the full console set:

```text
EXTS="sfc smc iso cso gba gb gbc nds dsi nes gen n64 bin"
```

Bare ROM images pass through when `file` identifies a console image (`*ROM image*`, `*Game Boy*`, ISO, filesystem). `image_size_in_archive` derives the extension from the matched image — `.gba`/`.nds` sizes extract correctly. Commit `0499a9f`.

## Emulator log-level tracing (2026-08-05)

mGBA is silent by default (0-byte log); its `--log-level` bitmask (0x7F = ALL) enables boot evidence:

```text
launch-emulator.sh {mgba} {rom} --emu-arg -l --emu-arg 127
```

`--emu-arg` passes flags before the ROM; `trace-evidence.sh` defaults now include GBA categories (`GBA DMA`, `GBA BIOS`, `GBA Serial I/O`, `SDL Events`). Result: 0 → 6180 trace lines on the MMZ2 boot. Commit `91a31ee`.

## Testing the server directly

The server speaks MCP over stdio — a handshake sequence confirms it:

```text
initialize → notifications/initialized → tools/list → tools/call
```

Each tool call routes through the wrapper → canonical chain; the keyed result lines prove the delegation. Full 8-tool listing and live calls verified 2026-08-05.

## Records

- `_codex/_bitacora/task-reference/20260805-mcp-verify-issue.md` — the extension-gap issue (fixed)
- `_codex/_bitacora/task-reference/20260805-mgba-trace-issue.md` — the silent-trace issue (fixed)
