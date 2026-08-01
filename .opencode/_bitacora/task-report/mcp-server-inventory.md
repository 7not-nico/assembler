# MCP Server Inventory

All MCP servers configured in `opencode.json` with status and dependency info.

## Active

| Server | Config Name | Type | Command | node_modules | Package deps |
|--------|------------|------|---------|-------------|--------------|
| `mcp-patlib` | `patlib` | local | `bun run tools/mcp-patlib/index.ts` | Symlink → root | `@modelcontextprotocol/sdk`, `zod` |
| `mcp-spec-audit` | `mcp-spec-audit` | local | `bun run tools/mcp-spec-audit/index.ts` | Symlink → root | `@modelcontextprotocol/sdk`, `zod` |
| `mcp-entity-audit` | `mcp-entity-audit` | local | `bun run tools/mcp-entity-audit/index.ts` | Symlink → root | `@modelcontextprotocol/sdk`, `zod` |
| `mcp-compartment-audit` | — | local | (auto-discovered in tools/) | Symlink → root | `zod`, `@modelcontextprotocol/sdk` |
| `mcp-findings` | `mcp-findings` | local | `bun run findings/.opencode/tools/mcp-findings/index.ts` | Own node_modules | `playwright-core`, `zod`, `@modelcontextprotocol/sdk`, `@xenova/transformers` |
| `mcp-arxiv` | `mcp-arxiv` | local | `bun run findings/.opencode/tools/mcp-arxiv/index.ts` | Own node_modules | `fast-xml-parser`, `cheerio`, `zod`, `@modelcontextprotocol/sdk` |
| `mcp-biorxiv` | `mcp-biorxiv` | local | `bun run findings/.opencode/tools/mcp-biorxiv/index.ts` | Own node_modules | `fast-xml-parser`, `cheerio`, `zod`, `@modelcontextprotocol/sdk` |
| `mcp-burst-alert` | `mcp-burst-alert` | local | `bun run tools/mcp-burst-alert/index.ts` | Own node_modules | `@modelcontextprotocol/sdk`, `zod`, `express`, `jose`, `ajv`, `hono`, `eventsource` |
| Playwright | `playwright` | local | `bunx @playwright/mcp@latest ...` | npx cache | `@playwright/mcp` |

## Remote (API-Based)

| Server | Config Name | URL | Purpose | API key in config |
|--------|------------|-----|---------|-------------------|
| Exa | `exa` | `https://mcp.exa.ai/mcp` | Web search | No (env?) |
| Context7 | `context7` | `https://mcp.context7.com/mcp` | Context search | ✅ (plaintext in opencode.json) |
| Parallel Search | `parallel-search` | `https://search.parallel.ai/mcp` | Parallel search | No (env?) |

## Disabled

| Server | Config Name | Status | Why |
|--------|------------|--------|-----|
| `mcp-patlib-vector` | `patlib-vector` | `"enabled": false` + dir moved to `_disabled/` | Vector search MCP, removed during tooling cleanup |
| Chrome DevTools | `chrome-devtools` | `"enabled": false` | Debugging tool, not needed |

## Startup Cost

| Server | Startup IO | Weight |
|--------|-----------|--------|
| `mcp-patlib` | None | Light |
| `mcp-spec-audit` | None | Light |
| `mcp-entity-audit` | None | Light |
| `mcp-compartment-audit` | None | Light |
| `mcp-findings` | DB open + schema migrations | Heavy |
| `mcp-arxiv` | DB open + schema migrations | Heavy |
| `mcp-biorxiv` | None (lazy DB) | Light |
| `mcp-burst-alert` | File watcher (recursive) | Medium (FS watch) |
| Playwright | Chromium process spawn | Heavy |

## Process Count

Each local MCP server starts as a separate `bun run` child process. With all enabled servers active, that's 9 processes on startup (8 local + 1 npx).
