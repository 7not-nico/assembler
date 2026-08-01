#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — show exactly what will be stripped from each file
# survey: identity-body-strip — plan view before executing removals

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

DIR = ENTITIES.join("identities")
files = Dir[DIR.join("IDENTITY.*.md")].sort

puts "=== Identity Body Strip Plan ==="
puts ""
puts "Stripping **Naming:** and **Part of:** lines (covered by backmatter)"
puts ""

offending = []

files.each do |f|
  text = File.read(f)
  id = File.basename(f, ".md")
  parts = text.split(/^---$/).reject(&:empty?)
  yml = YAML.safe_load(parts[1].strip) rescue {}

  body = text.split(/^---$/)[0].strip
  lines = body.split("\n")

  naming_lines = lines.select { |l| l.start_with?("**Naming:**") }
  partof_lines = lines.select { |l| l.start_with?("**Part of:**") }

  next if naming_lines.empty? && partof_lines.empty?

  offending << id
  puts "── #{id} ──────"
  puts "  keep: #{lines.first[0..90]}"
  naming_lines.each { |l| puts "  drop: #{l[0..90]}" }
  partof_lines.each { |l| puts "  drop: #{l[0..90]}" }
  puts "  bm:   group=#{yml["group"].inspect}  ring=#{yml["ring"].inspect}  naming=#{yml["naming"].inspect}"
  puts ""
end

puts "=== Summary ==="
puts "Files to edit: #{offending.size}"
puts offending.empty? ? "All identities already clean." : offending.join(", ")
