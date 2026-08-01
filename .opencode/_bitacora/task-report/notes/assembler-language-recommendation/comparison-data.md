# Language Comparison — Data Matrix

## At a Glance

| Criterion | TypeScript/Bun | Go | Rust |
|-----------|---------------|-----|------|
| **Current usage** | ✅ Dominant (43 libs, 23 tools, 12 MCPs) | ❌ None | ❌ None |
| **MCP SDK** | ✅ v1.28.0, Anthropic, most mature | ✅ v1.4.1, Google, production | ✅ v1.3.0, stable, community |
| **Binary compilation** | ✅ `bun build --compile` (~50-100MB) | ✅ `go build` (~5-20MB) | ✅ `cargo build` (~1-10MB) |
| **Cross-compilation** | ⚠️ `--target` flag, maturing | ✅ GOOS/GOARCH, best-in-class | ✅ target triples + rustup |
| **Startup time** | ~287ms | ~33ms | ~38ms |
| **Idle memory** | ~162MB | ~21MB | ~7MB |
| **Proxy latency (p50)** | 0.76ms | 0.50ms | 0.38ms |
| **Developer availability** | High, $40-115/hr | Niche, $50-140/hr | Critical shortage, $80-200+/hr |
| **Learning curve** | Low (TS/JS ecosystem) | Medium | Steep |
| **CI compile time** | N/A (no build, transpile only) | ~10s | ~60s |

## Cost-Benefit: Adding Go

| Pro | Con |
|-----|-----|
| 4-5x smaller binaries than Bun | Violates MAX.BUN.ONLY |
| 10x faster startup (33ms vs 287ms) | Duplicates shared lib/ infrastructure |
| 8x lower idle memory (21MB vs 162MB) | Needs parallel MCP server maintenance |
| Best cross-compilation in class | Team must learn/maintain second language |
| Go MCP SDK production-ready (Google) | Existing TypeScript MCP flow works today |

## Cost-Benefit: Adding Rust

| Pro | Con |
|-----|-----|
| 10-50x smaller binaries than Bun | Severe developer shortage, 80+ days to hire |
| 23x lower idle memory (7MB vs 162MB) | Steepest learning curve |
| Fastest proxy latency (0.38ms) | MAX.BUN.ONLY violation + lib duplication |
| Best for safety-critical components | Overkill for proxy-style MCP servers |

## Cost-Benefit: Staying with TypeScript/Bun

| Pro | Con |
|-----|-----|
| Follows all existing maxims & protocols | Larger binaries (~50-100MB) |
| Shared lib/ works for all tools | Higher memory (162MB idle) |
| One language, one toolchain | Slower startup (287ms) |
| Largest MCP SDK ecosystem | Bun compile still maturing |
| Existing 43 lib files, 23 tools, 12 MCPs | |

## MCP Server Performance — When Language Matters

The benchmark shows: **For proxy MCP servers, language doesn't matter.**
All 5 tested languages handle a proxy request in under 3ms. Network latency
(50-500ms) dominates.

Language matters only when:
- Processing large datasets in-memory on every tool call
- Running at edge with strict latency budgets
- Deploying to memory-constrained environments
- Cold start is critical (serverless functions)

## Decision Matrix

| Scenario | Pick |
|----------|------|
| Proxy MCP server (calls upstream API) | TypeScript/Bun — keep existing |
| Compute-heavy MCP (processes data) | **Keep TypeScript** — JSON lib optimization > language switch |
| Edge deployment (cold start critical) | Go |
| Memory-constrained environment | Rust |
| Existing tool/MCP server | TypeScript/Bun — rewrite unjustified |
| New binary-distributed CLI tool | Go or Bun compile (if MAX.BUN.ONLY binding) |
