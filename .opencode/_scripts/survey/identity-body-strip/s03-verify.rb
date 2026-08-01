#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify all identities have clean single-line bodies
# survey: identity-body-strip — post-strip verification

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

DIR = ENTITIES.join("identities")
files = Dir[DIR.join("IDENTITY.*.md")].sort

clean_count = 0
violations = []

files.each do |f|
  text = File.read(f)
  id = File.basename(f, ".md")
  body = text.split(/^---$/)[0].strip
  lines = body.split("\n").reject(&:empty?)

  has_naming = lines.any? { |l| l.start_with?("**Naming:**") }
  has_partof = lines.any? { |l| l.start_with?("**Part of:**") }

  if has_naming || has_partof
    violations << id
  else
    clean_count += 1
  end
end

puts "=== Identity Body Strip — Verification ==="
puts ""
puts "Clean (single-line body): #{clean_count}/#{files.size}"
puts "Still has Naming/Part of: #{violations.size}/#{files.size}"

if violations.any?
  puts ""
  puts "Remaining violations:"
  violations.each { |v| puts "  #{v}" }
  exit 1
else
  puts ""
  puts "Result: PASS — all identity bodies are single-line descriptions."
end
