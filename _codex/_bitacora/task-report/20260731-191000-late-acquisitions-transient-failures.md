# snes9x late acquisitions + transient launch failures

Timestamp: 2026-07-31 19:10

## What was done

### Acquisitions (5 new, library 26 → 31)

| Game | Variant | Size | Notes |
|------|---------|------|-------|
| Nosferatu (USA) | `/2` | 2,097,152 B | re-run of interrupted download; verified `NOSFERATU`, launched |
| Blues Brothers, The (USA) | `/4` | 524,288 B | re-download; identical content (CRC32 `82b97464`); transient launch FAIL |
| Prehistorik Man (USA) | `/2` | 1,048,576 B | Titus follow-up (browse `titus` + `titus the fox` empty; `prehistorik` hit) |
| Maui Mallard in Cold Shadow (USA) | `/1` | 3,145,728 B | Disney, Eurocom; 3 MiB LoROM |
| Gundam Wing: Endless Duel (Japan) | `/1` | 2,097,152 B | T-En Aeon Genesis v1.00 + FastROM hack; title probe reads `DDDDD` (patched header), `file` reads `GUNDAMW ENDLESSDUEL` |
| Harvest Moon (USA) | `/3` | 2,097,152 B | 8 KB SRAM save-backed |

### Phantom 2040 accident

Re-download of Blues Brothers used a mis-typed URL (`blues-brothers-145491/2` — that game page serves Phantom 2040). Acquired Phantom 2040 (USA) (Beta) by mistake. Correct Blues page: `the-blues-brothers-2-146925`, variant `/4`. Lesson: variant URLs derive from `browse-romsfun.sh` output, never from memory.

### Transient launch failures (2 occurrences)

Both Blues Brothers and Gundam Wing failed first launch with:

```
FAIL  emulator exited early — crash or missing window
X connection to :0 broken (explicit kill or server shutdown).
```

ROM content verified OK (CRC32 + checksum) in both cases. Immediate relaunch (`launch-rom.sh {rom}`) succeeded — `RUN pid=...`. Same failure signature after a fresh re-download, so not a corrupt ROM. No `pkill` in the toolchain (checked fetch/launch scripts + Ruby launcher). Pattern: transient X connection contention — relaunch once before diagnosing.

### Shared browser restart

`browse-romsfun.sh` reported "shared browser not running" mid-session — the browser had exited. `start-browser.sh` idempotent restart brought CDP 9222 back (UP, same profile). No data loss; subsequent searches fine.

## Open edges

- Phantom 2040 (USA Beta) acquired by accident (mis-typed URL) — **removed 2026-07-31 19:50**; library back to 30. The acquisition-consistency invariant and url-provenance pattern record the lesson.
- MCP browser tools still unavailable this session; script flow independent.
- Gundam Wing title probe reads patched header (`DDDDD`) — cosmetic; `file` + checksum OK.

## Todo state

Chain run: todo updated; report written; precept/pattern/procedure updates pending (URL provenance + transient launch retry).
