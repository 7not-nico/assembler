# Recommendation — Language Strategy

**Date**: 2026-07-24
**Author**: Agent analysis
**Status**: Draft for review

## Executive Summary

**Stay with TypeScript/Bun as primary language. Add Go for specific
binary-distributed MCP servers only if demonstrated need arises.**

The evidence does not justify a full or partial language migration:

1. **Benchmark data shows language irrelevant for proxy MCP servers**
   - All 5 tested languages under 3ms proxy latency
   - Network latency (50-500ms) dominates — framework overhead is noise
   - JSON library optimization (sonic, orjson, typed serde) beats language switching

2. **Patlib maxims and protocols assume TypeScript throughout**
   - MAX.BUN.ONLY mandates Bun runtime for all tooling
   - MAX.CLI.TO.MCP assumes shared lib/ extraction within same language
   - PROT.MCP.TRANSPORT is TypeScript SDK-specific
   - Adding Go/Rust requires: maxim overrides, protocol updates, lib duplication

3. **Existing investment in TypeScript is large**
   - 43 shared lib files in `.opencode/_lib/`
   - 23 tool files, 12+ MCP servers
   - All entity tooling (write-sync, read-selection, etc.) is TypeScript
   - Rewriting or bifurcating the codebase is disproportionate to the gain

4. **Bun provides adequate binary compilation**
   - `bun build --compile --target=bun-linux-x64` works today
   - Cross-compiles to linux/darwin/windows × x64/arm64
   - Bundles all deps + runtime into single executable
   - Tradeoff: larger binary (~50-100MB), higher memory (~162MB idle)

## When to Add Go

A narrow exception exists for **performance-critical binary tools** that:
- Run at edge with sub-50ms cold start requirements (serverless)
- Need single-digit-MB memory footprint
- Are distributed as standalone binaries to external users

If such a tool emerges:
1. **Override MAX.BUN.ONLY** via documented exception — scope to that tool only
2. **Use mark3labs/mcp-go** SDK (battle-tested, 7.8K stars, production)
3. **Keep shared lib in TypeScript** — Go tool is self-contained
4. **Update PROT.MCP.TRANSPORT** to note alternative SDK usage
5. **Document binary-invocation pattern** in PROT.MCP.SERVER

## When to Add Rust

Rust offers marginal benefits over Go for this project's use case:
- Lower memory (7MB vs 21MB)
- Slightly faster proxy (0.38ms vs 0.50ms)
- Smaller binaries (~1-10MB vs ~5-20MB)

These advantages do not offset the developer shortage (80+ days to hire,
50-80% salary premium) and steep learning curve. **Do not add Rust**
unless a specific component requires sub-millisecond latency or
memory safety guarantees that Go cannot provide.

## Action Items

1. **Document this decision** in a new protocol or update MAX.BUN.ONLY
   to clarify the override path for binary-distributed tools
2. **Benchmark Bun compile** — measure actual binary size for a real MCP
   server (e.g., mcp-patlib) to verify production viability
3. **If edge deployment arises**, prototype a Go MCP server with mcp-go SDK
   and benchmark against Bun-compiled equivalent
4. **Optimize existing TypeScript MCP servers** — switch to faster JSON
   parsing (sonic equivalent via Bun), add connection pooling

## References

- MAX.BUN.ONLY — `.opencode/entities/maxims/MAX.BUN.ONLY.md`
- MAX.CLI.TO.MCP — `.opencode/entities/maxims/MAX.CLI.TO.MCP.md`
- MAX.CODE.LAYERS — `.opencode/entities/maxims/MAX.CODE.LAYERS.md`
- PROT.MCP.TRANSPORT — `.opencode/entities/protocols/PROT.MCP.TRANSPORTmd`
- PROT.MCP.SERVER — `.opencode/entities/protocols/PROT.MCP.SERVERmd`
- MCP Benchmark — `blog.wentland.io/blog/mcp-benchmark-5-languages/`
- MCP SDK Comparison — `mcpize.com/blog/choose-mcp-server-language`
- Bun Executables — `bun.com/docs/bundler/executables`
