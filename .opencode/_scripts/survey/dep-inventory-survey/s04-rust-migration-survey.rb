#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey _lib/ TypeScript modules for Rust _rustlib/ migration
# survey: dep-inventory-survey
# analyzes dependency chains, module boundaries, and designs the Rust crate architecture

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..", ".opencode").expand_path
LIB_DIR = ROOT.join("_lib")
RUSTLIB_DIR = ROOT.join("_rustlib")
RS_DIR = Pathname.new(__dir__).join("..", "..", "_rs").expand_path

SEPARATOR = "─" * 72

# IO: scan .ts files for exports and imports
ScanModule = ->(path) {
  text = File.read(path)
  name = path.basename(".ts").to_s
  exports = text.scan(/\/\/ exports:\s*(.*)/).flatten.first || ""
  purity = text.scan(/\/\/ purity:\s*(.*)/).flatten.first || "unspecified"
  deps = text.scan(/from\s+["']([^"']+)["']/).flatten
           .select { |d| !d.start_with?(".") }
           .map { |d|
             parts = d.split("/")
             d.start_with?("@") ? "#{parts[0]}/#{parts[1]}" : parts[0]
           }.uniq
  { name: name, exports: exports, purity: purity, npm_deps: deps, path: path }
}

# IO: find all .ts files
LibModules = -> {
  Dir[LIB_DIR.join("*.ts")].map { |p| ScanModule.call(Pathname.new(p)) }
}

# IO: find all tool files and their _lib deps
ToolScan = -> {
  Dir[ROOT.join("tools", "*.ts")].map { |p|
    text = File.read(p)
    name = Pathname.new(p).basename(".ts").to_s
    lib_deps = text.scan(/from\s+["']\.\.\/_lib\/([^"']+)["']/).flatten.uniq.sort
    { name: name, lib_deps: lib_deps }
  }
}

# IO: find existing _rs/ Rust modules
RsModules = -> {
  Dir[RS_DIR.join("src", "*.rs")].map { |p|
    name = Pathname.new(p).basename(".rs").to_s
    { name: name, path: p }
  }
}

# --- Main ---

puts "#{SEPARATOR}"
puts "Rust _rustlib/ Migration Survey"
puts "  Source:     #{LIB_DIR}"
puts "  Target:     #{RUSTLIB_DIR}"
puts "  Rust ref:   #{RS_DIR} (#{RsModules.call.size} existing modules)"
puts "#{SEPARATOR}"
puts

# 1. Module inventory
modules = LibModules.call
pure_modules = modules.select { |m| m[:purity] == "pure" }
io_modules = modules.select { |m| m[:purity] != "pure" }

puts "1. _lib/ Module Inventory (#{modules.size} total)"
puts
puts "   Pure (#{pure_modules.size}): #{pure_modules.map { |m| m[:name] }.join(", ")}"
puts "   IO (#{io_modules.size}): #{io_modules.map { |m| m[:name] }.join(", ")}"
puts

# 2. Dependency chain analysis
tools = ToolScan.call

# Build reverse dep map: which tools depend on which _lib modules?
lib_consumers = Hash.new { |h, k| h[k] = [] }
tools.each do |t|
  t[:lib_deps].each { |d| lib_consumers[d] << t[:name] }
end

puts "2. Tool Dependency Graph — _lib modules sorted by consumer count"
puts
ranked = lib_consumers.sort_by { |_, v| -v.size }
ranked.each_with_index do |(lib, consumers), i|
  puts "   #{'%2d' % (i+1)}. #{lib.ljust(25)} #{consumers.size} tools"
  consumers.each { |c| puts "       ← #{c}" }
end
puts

# 3. Existing _rs/ overlap
rs_mods = RsModules.call
puts "3. Existing _rs/ Modules (#{rs_mods.size})"
puts
rs_mods.each { |m| puts "   #{m[:name]}.rs" }
puts
puts "   Note: _rs/ ports _rb/ (Ruby entity audit core)."
puts "   _rustlib/ must port _lib/ (TypeScript tools core)."
puts "   These are separate concerns — _rs/ cannot substitute."
puts

# 4. NPM dependency audit for Rust equivalents
all_npm = modules.flat_map { |m| m[:npm_deps] }.uniq.sort
puts "4. NPM Dependency → Rust Equivalent"
puts
npm_map = {
  "js-yaml" => "serde_yaml",
  "@modelcontextprotocol/sdk" => "manual MCP/JSON-RPC over stdio",
  "@xenova/transformers" => "candle or ort (ONNX runtime)",
  "zod" => "serde + schemars (compile-time validation)",
  "@opencode-ai/plugin" => "manual stdio tool protocol",
}
npm_map.each { |npm, rust| puts "   #{npm.ljust(35)} → #{rust}" }
puts

# 5. Recommended architecture
puts "5. _rustlib/ Crate Architecture"
puts
puts "   .opencode/_rustlib/"
puts "   ├── Cargo.toml"
puts "   ├── src/"
puts "   │   ├── main.rs         # MCP stdio server binary"
puts "   │   ├── lib.rs          # Re-exports + protocol dispatch"
puts "   │   ├── db.rs           # SQLite connection (rusqlite)"
puts "   │   ├── paths.rs        # Entity path discovery"
puts "   │   ├── parse.rs        # YAML frontmatter/backmatter"
puts "   │   ├── entity.rs       # Entity lookup + metadata"
puts "   │   ├── rank.rs         # RRF ranking"
puts "   │   ├── vector.rs       # FTS5 + vector search"
puts "   │   └── types.rs        # Shared type definitions"
puts

# 6. Migration phases
puts "6. Migration Phases"
puts
puts "   Phase │ Modules              │ Replaces      │ Risk"
puts "   ──────┼──────────────────────┼───────────────┼──────"
puts "   P0    │ db, paths, parse     │ db.ts, etc.   │ Low — foundation, no existing usage without"
puts "   P1    │ entity, rank, types  │ entity-lookup │ Low — pure transformations + DB reads"
puts "   P2    │ vector               │ vector-*.ts   │ Medium — ONNX embedder replacement"
puts "   P3    │ main (MCP binary)    │ mcp-patlib    │ Medium — replaces live MCP server"
puts

# 7. Risk assessment
puts "7. Risk Assessment"
puts
puts "   Database layer (db.rs):"
puts "     Current: bun:sqlite (SQLite via Bun runtime)"
puts "     Target:  rusqlite (native SQLite via Rust)"
puts "     Risk:    LOW — schema-compatible, same SQL"
puts "     Note:    WAL mode, FTS5 virtual tables must match existing patlib.db"
puts
puts "   Path discovery (paths.rs):"
puts "     Current: Node fs + path modules"
puts "     Target:  std::fs + walkdir crate"
puts "     Risk:    LOW — pure filesystem operations"
puts "     Note:    Must match PATLIB_ROOT resolution from _rs/paths.rs convention"
puts
puts "   Frontmatter parsing (parse.rs):"
puts "     Current: js-yaml (JavaScript YAML parser)"
puts "     Target:  serde_yaml (Rust YAML parser)"
puts "     Risk:    LOW — serde_yaml is mature, schema-driven"
puts "     Note:    Frontmatter/delimiter regex must match _rs/frontmatter.rs"
puts
puts "   Vector embedding (embedder-onnx.ts → vector.rs):"
puts "     Current: @xenova/transformers (ONNX runtime via dynamic import)"
puts "     Target:  candle or ort crate (ONNX Runtime for Rust)"
puts "     Risk:    HIGH — model loading, ONNX compatibility, GPU vs CPU"
puts "     Note:    Defer to P2 after P0+P1 are stable. Keep TypeScript embedder as fallback."
puts
puts "   MCP protocol (main.rs binary):"
puts "     Current: @modelcontextprotocol/sdk (TypeScript)"
puts "     Target:  Manual JSON-RPC 2.0 over stdin/stdout"
puts "     Risk:    LOW — protocol is well-defined, ~200 lines for basic implementation"
puts "     Note:    Must implement: initialize, tools/list, tools/call. Same interface as mcp-patlib."
puts

puts SEPARATOR
puts "Recommendation: Start with P0 (db.rs + paths.rs + parse.rs)"
puts "  These 3 modules cover 12 tool files (most critical path)"
puts "  Pure functions in Rust with Cargo.toml, test immediately"
puts "  No MCP endpoint needed until P3 — test via CLI first"
puts SEPARATOR
