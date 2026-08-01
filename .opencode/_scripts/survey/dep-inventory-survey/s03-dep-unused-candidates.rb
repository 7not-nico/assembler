#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — identify unused dep candidates with removal rationale
# survey: dep-inventory-survey
# cross-references declared-not-used deps against lockfile for transitive role, runtime use, or safe removal

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..", ".opencode").expand_path
PKG_JSON = ROOT.join("package.json")
BUN_LOCK = ROOT.join("bun.lock")
SEPARATOR = "─" * 72

abort("FATAL: #{PKG_JSON} not found") unless File.exist?(PKG_JSON)
abort("FATAL: #{BUN_LOCK} not found") unless File.exist?(BUN_LOCK)

pkg = JSON.parse(File.read(PKG_JSON))
declared = pkg["dependencies"] || {}
overrides = pkg["overrides"] || {}
# Preprocess bun.lock: strip trailing commas from objects and arrays before JSON parse
StripTrailingCommas = ->(text) {
  text.gsub(/,\s*(\}|\])/, '\1')
}

bun_lock_raw = StripTrailingCommas.call(File.read(BUN_LOCK))
bun_lock = JSON.parse(bun_lock_raw)

# Track which declared deps are actually imported in source
# Hardcoded from s01 results — authoritative import scan data
USED_DEPS = %w[
  @modelcontextprotocol/sdk
  @opencode-ai/plugin
  @xenova/transformers
  js-yaml
  zod
].freeze

# Builtin modules that need no declaration
BUILTINS = %w[bun:sqlite fs path].freeze

# The 5 declared-but-not-used candidates
CANDIDATES = %w[@huggingface/transformers @toon-format/toon playwright-core sharp wavefile].freeze

# Extract dependency tree from bun.lock packages section
packages = bun_lock["packages"] || {}

puts "=== Dep Removal Candidates — Impact Analysis ==="
puts "  Root: #{ROOT}"
puts "  Total declared: #{declared.size}"
puts "  Unused candidates: #{CANDIDATES.size}"
puts

CANDIDATES.sort.each do |candidate|
  declared_ver = declared[candidate]
  override_ver = overrides[candidate]
  pkg_entry = packages[candidate]
  transitive_dependents = packages.select { |_name, info|
    info.is_a?(Array) && info[2].is_a?(Hash) && (info[2]["dependencies"] || {}).key?(candidate)
  }.map { |name, _| name }.sort

  puts "#{SEPARATOR}"
  puts "Candidate: #{candidate}"
  puts "  Declared: #{declared_ver}"
  puts "  Override: #{override_ver}" if override_ver
  puts

  if pkg_entry
    pkg_info = pkg_entry.is_a?(Array) ? pkg_entry[2] : {}
    puts "  Resolved version: #{pkg_entry[0]}"
    puts "  Own deps: #{pkg_info["dependencies"]&.keys&.join(", ") || "(none)"}"
    puts "  Peer deps: #{pkg_info["peerDependencies"]&.keys&.join(", ") || "(none)"}" if pkg_info["peerDependencies"]

    if candidate == "sharp"
      puts
      puts "  ⚠  sharp is a transitive dependency of @huggingface/transformers"
      puts "     sharp override #{override_ver} exists — verify rationale"
      puts "     If @huggingface/transformers removed, sharp may still resolve"
      puts "     from other transitive paths in the dep tree"
    end

    if candidate == "playwright-core"
      puts
      puts "  ⚠  Playwright MCP server uses `bunx @playwright/mcp@latest`"
      puts "     This fetches at runtime, NOT from local node_modules"
      puts "     playwright-core in deps is redundant for this use case"
    end
  else
    puts "  (not resolved in bun.lock — will fail on install)"
  end

  if transitive_dependents.any?
    puts
    puts "  Transitively required by:"
    transitive_dependents.each { |d| puts "    ← #{d}" }
    puts
    puts "  → NOT safe to remove without refactoring those dependents"
  else
    puts
    puts "  No other package depends on #{candidate}"
    puts "  → SAFE to remove from package.json"
  end

  # Version mismatch check
  if candidate == "@huggingface/transformers"
    puts
    puts "  Note: @xenova/transformers IS used (embedder-onnx.ts)"
    puts "  Both packages serve similar purposes (HuggingFace transformers in JS)"
    puts "  @huggingface/transformers is the newer successor"
    puts "  Action: verify @xenova/transformers still maintained, or migrate to @huggingface"
  end

  puts
end

puts SEPARATOR
puts "Summary:"
puts

removable = []
needs_review = []

CANDIDATES.each do |c|
  pkg_entry = packages[c]
  transitive_dependents = packages.select { |_name, info|
    info.is_a?(Array) && info[2].is_a?(Hash) && (info[2]["dependencies"] || {}).key?(c)
  }.map { |name, _| name }

  if transitive_dependents.empty?
    removable << c
  else
    needs_review << [c, transitive_dependents]
  end
end

if removable.any?
  puts "Safe to remove (#{removable.size}):"
  removable.each { |r| puts "  ✓ #{r}" }
end

if needs_review.any?
  puts
  puts "Needs review (#{needs_review.size}):"
  needs_review.each { |r, deps| puts "  ? #{r} (required by: #{deps.join(", ")})" }
end

puts
puts SEPARATOR
puts "Recommendation:"
puts
puts "  Run: bun remove #{CANDIDATES.select { |c| removable.include?(c) }.join(" ")}"
puts "  Then: bun install"
puts "  Then: re-run s01 to verify no breakage"
