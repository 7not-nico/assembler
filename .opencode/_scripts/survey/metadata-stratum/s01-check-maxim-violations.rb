#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — check MAX.METADATA.STRATUM against maxim line-junction rules
# survey: metadata-stratum — confirm violation before maxim→protocol conversion

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/body"
require_relative "../../_rb/report"

path = Dir[EntityGlob.call("maxims")].find { |p| File.basename(p, ".md") == "MAX.METADATA.STRATUM" }
unless path
  puts "MAX.METADATA.STRATUM not found — already removed."
  exit 0
end

text = File.read(path)
fm = ParseFrontmatter.call(text)
base = File.basename(path, ".md")
id = fm ? fm[:id] : base

cat = ExtractCatSection.call(text)
violations = []

cat.each_with_index do |line, i|
  if line.start_with?("|")
    violations << [id, "table row", line[0..60], "cat lines must use `- ` prefix, not table"]
  elsif !line.start_with?("- ")
    violations << [id, "no `- ` prefix", line[0..60], "expected `- **{Term}** — {description}`"]
  end
end

puts "=== MAX.METADATA.STRATUM — Maxim Format Audit ==="
puts
if violations.empty?
  puts "ok — 0 violations (maxim format is valid)"
else
  puts "violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
  puts
  puts "Recommendation: delete MAX.METADATA.STRATUM, create PROT.METADATA.STRATUM instead."
end
