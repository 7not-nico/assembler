#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — audit entity directory names vs paths.ts hardcoded paths
# survey: dir-path-alignment — check alignment before fixing broken paths

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"

# Mapping actual dir names to their expected paths.ts constant and value
PATHS = {
  "abstractions"      => { const: "ABSTRACTIONS_DIR",  ts: "abstractions" },
  "algorithms"        => { const: nil,                  ts: nil },
  "apologias"         => { const: "APOLOGIAS_DIR",      ts: "apologias" },
  "archives"          => { const: nil,                  ts: nil },
  "bash"              => { const: "BASH_DIR",           ts: "bash" },
  "biology"           => { const: "BIO_DIR",            ts: "biological" },
  "chemistry"         => { const: "CHEM_DIR",           ts: "chemical" },
  "cognitions"        => { const: "COGNITIONS_DIR",     ts: "cognitions" },
  "concepts"          => { const: "CONCEPTS_DIR",       ts: "concepts" },
  "definitions"       => { const: "DEFINITIONS_DIR",    ts: "definitions" },
  "identities"        => { const: "IDENTITIES_DIR",     ts: "identities" },
  "illustrations"     => { const: "ILLUSTRATIONS_DIR",  ts: "illustrations" },
  "investigations"    => { const: nil,                  ts: nil },
  "linguistics"       => { const: "LINGUISTICS_DIR",    ts: "linguistics" },
  "machine-learning"  => { const: "ML_DIR",             ts: "ml" },
  "manifests"         => { const: "MANIFESTS_DIR",      ts: "manifests" },
  "maxims"            => { const: "MAXIMS_DIR",         ts: "maxims" },
  "nexus"             => { const: "NEXUS_DIR",          ts: "nexus" },
  "notes"             => { const: nil,                  ts: nil },
  "patterns"          => { const: "PATTERNS_DIR",       ts: "patterns" },
  "persons"           => { const: "PERSONS_DIR",        ts: "persons" },
  "protocols"         => { const: "PROTOCOLS_DIR",      ts: "protocols" },
  "references"        => { const: "REFS_DIR",           ts: "references" },
  "ruby"              => { const: "RUBY_DIR",           ts: "ruby" },
  "specifications"    => { const: "SPECIFICATIONS_DIR", ts: "specifications" },
  "taxonomies"        => { const: "TAXONOMY_DIR",       ts: "taxonomy" },
  "terms"             => { const: "TERMS_DIR",          ts: "terms" },
}

rows = []
Dir.children(ENTITIES).sort.each do |dir|
  dirpath = ENTITIES.join(dir).to_s
  next unless File.directory?(dirpath)

  info = PATHS[dir]
  expected = info && info[:ts] ? info[:ts] : "—"
  match = dir == expected ? "✓" : "✗"
  symlink = File.symlink?(dirpath) ? "symlink → #{File.readlink(dirpath)}" : "—"
  count = Dir[File.join(dirpath, "*.md")].size.to_s

  rows << [dir, expected, match, symlink, count]
end

puts "=== Entity Directory Alignment Audit ==="
puts
puts Table.call(rows, %w[Actual-Dir paths.ts Match Symlink? Files])
puts

mismatch = rows.count { |r| r[2] == "✗" }
symlinks = rows.count { |r| r[3].include?("symlink") }
broken = rows.count { |r| r[3].include?("symlink") && !File.exist?(ENTITIES.join(File.readlink(ENTITIES.join(r[0])).to_s).to_s) rescue false }
puts "Total dirs: #{rows.size}"
puts "Mismatched paths: #{mismatch}"
puts "Symlinks: #{symlinks}"
puts "Broken symlinks: #{broken}"
