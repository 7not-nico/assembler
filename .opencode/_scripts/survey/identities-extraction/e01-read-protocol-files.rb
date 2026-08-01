#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — dump all PROT.*.IDENTITY frontmatter for extraction reference
# survey: identities-extraction

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

files = Dir[EntityGlob.call("protocols")].select { |p|
  File.basename(p, ".md").match?(/\.IDENTITY$/)
}.sort

rows = []
files.each do |path|
  base = File.basename(path, ".md")
  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  body_text = text.sub(/\A---\s*\n.*?\n---\s*\n/m, "").strip
  body_preview = body_text.lines.first(3).map(&:strip).join(" ")[0..80]

  rows << [
    base,
    fm[:title].to_s[0..40],
    (fm[:summary].to_s rescue "")[0..50],
    fm[:source].to_s,
    fm[:enforcement].to_s,
    fm[:tags].is_a?(Array) ? fm[:tags].join(",") : fm[:tags].to_s,
    body_preview
  ]
end

puts "=== PROT.*.IDENTITY — Extraction Reference ==="
puts
puts Table.call(rows, %w[ID Title Summary Source Enforcement Tags Body])
puts
puts "#{rows.size} protocol identity files"
