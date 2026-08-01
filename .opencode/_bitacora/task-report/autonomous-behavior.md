# Autonomous Behavior Audit

What runs automatically when opencode starts in `assembler/` or as background system services.

## OpenCode Startup Chain

When `opencode assembler/` is launched:

```
1. Read opencode.json
2. Start MCP servers (8 local + 1 npx) ─── each a separate bun run process
3. Load instruction rules from .opencode/rules/
4. Discover tools in .opencode/tools/ ─── validates each tool file
5. Load plugins from .opencode/plugins/ ─── register event handlers
6. Load agent skills from .opencode/skills/ and .opencode/.agents/skills/
```

### MCP Servers (Auto-Started)

| Server | Start method | Resource impact |
|--------|-------------|-----------------|
| `mcp-patlib` | `bun run tools/mcp-patlib/index.ts` | Light |
| `mcp-spec-audit` | `bun run tools/mcp-spec-audit/index.ts` | Light |
| `mcp-entity-audit` | `bun run tools/mcp-entity-audit/index.ts` | Light |
| `mcp-compartment-audit` | `bun run tools/mcp-compartment-audit/index.ts` | Light |
| `mcp-findings` | `bun run findings/.opencode/tools/mcp-findings/index.ts` | Heavy (DB + schema migrations) |
| `mcp-arxiv` | `bun run findings/.opencode/tools/mcp-arxiv/index.ts` | Heavy (DB + schema migrations) |
| `mcp-biorxiv` | `bun run findings/.opencode/tools/mcp-biorxiv/index.ts` | Light (lazy DB) |
| `mcp-burst-alert` | `bun run tools/mcp-burst-alert/index.ts` | Medium (file watcher) |
| `playwright` | `bunx @playwright/mcp@latest` | Heavy (Chromium process) |

Total: 9 child processes, including 2 heavy DB inits and 1 browser process.

### Plugins (Event-Driven)

| Plugin | Trigger | Behavior |
|--------|---------|----------|
| `auto-sync.ts` | `file.edited` in `.opencode/terms/` or `.opencode/protocols/` | Debounced (2s) auto-sync markdown → DB |
| `burst-alert.ts` | `file.edited` in `.opencode/`, `objects/`, `src/`, `stud/` | Detects rapid file changes, plays `medabots-opening.mp3` |
| `session-saver.ts` | Session events (created, updated, deleted, compacted) | Persists session metadata to `sessions.db` |
| `audit-events.ts` | File events | Audit logging |
| `bash-guard.ts` | Bash commands | Restricts/guards bash execution |
| `cmd-audit.ts` | Command execution | Audits commands |
| `log-mcp.ts` | MCP tool calls | Logs MCP search/usage |
| `ref-integrity.ts` | File changes | Checks cross-reference integrity |

### Auto-Sync Plugin Detail

`auto-sync.ts` watches `.opencode/terms/` and `.opencode/protocols/` for edits. When a file changes:
1. Waits 2s debounce
2. Reads the changed file
3. Syncs content to `patlib.db`
4. This happens without user intervention — file save → auto-sync

This means editing term or protocol files triggers background DB writes.

### Burst Alert Plugin Detail

`burst-alert.ts` watches the entire assembler tree (`.opencode/`, `objects/`, `src/`, `stud/`). When rapid file changes exceed threshold:
1. Plays `objects/medabots-opening.mp3` via `paplay`
2. Duration: 10s (configurable in `burst-config.json`)
3. Counts alerts in `.burst-state.json`

Current state: 4 alerts fired.

## Background System Services

| Service | Status | Behavior |
|---------|--------|----------|
| `clawdbot-gateway.service` | Auto-restart (failing?) | Node.js gateway on port 18789 |
| `elephant.service` | Active | Personal service, starts with graphical session |
| `voxtype.service` | Active | Push-to-talk voice-to-text daemon |
| `arch-update.timer` | 23:00 daily | Arch Linux update checker |
| `omarchy-battery-monitor.timer` | ~1min intervals | Battery level monitor |
| `psd-resync.timer` | 23:00 daily | Profile-sync-daemon resync |

## What Takes Control of the Terminal

Based on this audit, several things can interfere with the terminal:

1. **Shebang CLI tool validation on startup** — if any tool file in `.opencode/tools/` uses `#!/usr/bin/env bun` instead of `export default tool({...})`, opencode's startup validation errors are printed to the terminal.
2. **Burst alert audio** — if file changes trigger the burst threshold, `medabots-opening.mp3` plays for 10 seconds, briefly taking over audio.
3. **Plugin auto-execution** — saving a term or protocol file triggers background DB sync, which may produce output.
4. **Chromium process** — Playwright MCP starts a full Chromium browser, consuming CPU/memory.
5. **9 MCP server processes** — each consuming memory and CPU on startup.

## Recommendations

1. **Convert shebang CLIs to plugin format** or keep them in `_disabled/` — resolves startup validation errors.
2. **Consider disabling burst-alert** if file watcher audio is disruptive.
3. **Consider lazy-start for Playwright** — only launch Chromium when actually needed, not on every session start.
4. **Reduce server count** — findings MCP servers (findings, arxiv, biorxiv) could be merged into one with shared DB init.
