#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — report every identity with its body sections
# survey: identities-audit

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/patlib"
require_relative "../../_rb/rings"
require_relative "../../_rb/report"

rows = []

Dir[EntityGlob.call("identities")].sort.each do |path|
  base = File.basename(path, ".md")
  text = File.read(path)
  meta = ParseBackmatter.call(text)
  next unless meta

  body = text.sub(/---\s*\n.*?\n---\s*\z/m, "").strip
  has_defn = body.match?(/\A\*\*[^*]+\*\*\s*—/)
  has_naming = body.include?("**Naming:**")
  has_part = body.include?("**Part of:**")

  src = meta[:source].to_s
  ring_info = IdToRing.call(base)
  ring_label = ring_info ? "R#{ring_info[:ring]} #{ring_info[:group]}" : "project-local"

  rows << [
    base,
    meta[:title].to_s[0..40],
    has_defn ? "✓" : "✗",
    has_naming ? "✓" : "✗",
    has_part ? "✓" : "✗",
    ring_label,
    src
  ]
end

puts "=== Identity Coverage Report ==="
puts
puts Table.call(rows, %w[Identity Title Definition Naming Ring Group Source])
puts
summary = rows.map { |r| r[2..4] }.flatten
ok = summary.count("✓")
total = summary.size
puts "Sections: #{ok}/#{total} complete (#{(ok * 100 / total).round}%)"
