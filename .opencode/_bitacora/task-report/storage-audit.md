# Storage Audit

Disk usage by directory.

## Top-Level Directories

| Directory | Size | Notes |
|-----------|------|-------|
| `findings/` | 1.2G | Research findings MCP servers + node_modules |
| `code-dives/` | 985M | Third-party code repos + node_modules |
| `one-timers/` | 974M | One-off projects + node_modules |
| `_findings/` | 379M | Second findings directory |
| `homophones/` | 5.7M | Homophone DB |
| `common/` | 3.2M | Shared libs (bitacora, nerdfont) |
| `study-sessions/` | 1.7M | Study trackers |
| `kirby-shooter/` | 148K | Game prototype |
| `stud/` | 100K | Study content |
| `pythontts-cli/` | 52K | Python TTS CLI |

## Largest Space Consumers

1. **`findings/`** (1.2G) — MCP servers with heavy node_modules (`@xenova/transformers`, Playwright, etc.)
2. **`code-dives/`** (985M) — Cloned repos, node_modules, and build artifacts
3. **`one-timers/`** (974M) — Ludoteca and other projects with node_modules
4. **`_findings/`** (379M) — Duplicate or cached findings data

## `.opencode/` Breakdown

| Path | Approx size | Notes |
|------|-------------|-------|
| `.opencode/node_modules/` | ~200M | Shared packages (effect, @modelcontextprotocol/sdk, etc.) |
| `.opencode/tools/mcp-burst-alert/node_modules/` | ~50M | express, jose, ajv, eventsource |
| `.opencode/.backups/` | Varies | Entity backups |
| `.opencode/patlib.db` | ~1-5M | Main DB |

## PDF Storage

~500 PDFs in assembler root, estimated 2-3 GB total (not counted above — they're in root, not subdirectories).

## Recommendations

1. **`findings/`** and **`one-timers/`** dominate disk usage. Consider cleaning old node_modules or using shared symlink like the root tools do.
2. **`_findings/`** (379M) — check if this is a duplicate of `findings/` or has unique data.
3. **`.opencode/node_modules/`** has many packages from `effect` (~100M+) — verify these are all needed.
4. PDFs (~2-3 GB) could be archived or deduplicated (some papers appear multiple times with different names).
