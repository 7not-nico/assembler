# Papers & Benchmarks — Language Comparison

## MCP Server Benchmark (desty2k/mcp-benchmark, 2026-04-07)

Full writeup: https://blog.wentland.io/blog/mcp-benchmark-5-languages/
Repo: https://github.com/desty2k/mcp-benchmark

Benchmarked Python, Rust, Go, TypeScript (Node 24), C# over Streamable HTTP.
Same 6 tools, same backend, 1000 req/tool, sequential.

### Proxy Latency (echo tool, p50)

| Python | Rust | Go | TypeScript | C# |
|--------|------|-----|------------|-----|
| 2.25ms | 0.38ms | 0.50ms | 0.76ms | 0.60ms |

**Key finding**: All under 3ms. Network latency (50-500ms) dominates. Language irrelevant for proxy MCP servers.

### Compute Latency (p50)

| Tool | Python | Rust | Go | TypeScript | C# |
|------|--------|------|-----|------------|-----|
| analyze_dataset (4MB JSON) | 14.8ms | 11.4ms | **9.6ms** | 11.1ms | 15.9ms |
| extract_transform (2MB text) | 6.3ms | 1.5ms | 3.5ms | 4.8ms | **1.0ms** |

### Startup & Memory

| Metric | Python | Rust | Go | TypeScript | C# |
|--------|--------|------|-----|------------|-----|
| Startup (ms) | 615 | 38 | **33** | 287 | 612 |
| Idle RSS (MB) | 97 | **7** | 21 | 162 | 221 |
| Load RSS (MB) | 185 | 169 | **128** | 527 | 340 |

**Key finding**: Go has fastest startup (33ms). Rust lowest idle memory (7MB).
TypeScript idle at 162MB — partly SDK design (new instance per request in stateless mode).

### JSON Library Effect

| Language | Std JSON | Optimized | Speedup |
|----------|----------|-----------|---------|
| Go | 43ms (encoding/json) | 9.6ms (sonic) | 4.5x |
| Rust | 30ms (untyped serde) | 11.4ms (typed structs) | 2.7x |
| Python | 21ms (json.loads) | 14.8ms (orjson) | 1.4x |

**Key finding**: JSON library choice matters more than language switching.

## MCP SDK Maturity (mcpize.com, 2026-03-06)

https://mcpize.com/blog/choose-mcp-server-language

| SDK | Version | Status | Backer |
|-----|---------|--------|--------|
| TypeScript | 1.28.0 | Stable | Anthropic |
| Python | 1.26.0 | Stable | Anthropic |
| Go | 1.4.1 | Production | Google |
| Rust | 1.3.0 | Stable | Community |
| C# | 1.1.0 | Stable | Microsoft |

## Binary Compilation

### Bun `--compile`

- Cross-compile: `--target=bun-linux-x64`, `bun-darwin-arm64`, `bun-windows-x64`
- Baseline vs modern CPU variants
- Bundles Bun runtime (~50-100MB binary)
- Supports all Bun/Node.js APIs natively
- Can embed SQLite databases, assets

### Go `go build`

- Cross-compile: `GOOS`/`GOARCH` env vars — trivial, best-in-class
- Pure Go: fully static, no C deps needed
- Binary size: ~5-20MB
- `CGO_ENABLED=0` for full cross-compilation

### Rust `cargo build --release`

- Cross-compile: `rustup target add` + target triples
- Binary size: ~1-10MB with `opt-level=z`, LTO
- Needs C toolchain for cross targets (or zig cc)
