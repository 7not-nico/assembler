#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — audit all IDENTITY.*.md for Naming/Part of body lines
# survey: identity-body-strip — inventory which files need stripping

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

DIR = ENTITIES.join("identities")
files = Dir[DIR.join("IDENTITY.*.md")].sort

rows = []
total_naming = 0
total_partof = 0

files.each do |f|
  text = File.read(f)
  id = File.basename(f, ".md")
  body = text.split(/^---$/)[0].strip
  lines = body.split("\n")

  has_naming = lines.any? { |l| l.start_with?("**Naming:**") }
  has_partof = lines.any? { |l| l.start_with?("**Part of:**") }
  total_naming += 1 if has_naming
  total_partof += 1 if has_partof

  rows << [id, has_naming ? "Yes" : "", has_partof ? "Yes" : "", lines.size.to_s]
end

puts "=== Identity Body Strip Audit ==="
puts ""
puts Table.call(rows, %w[File Has_Naming Has_Part_of Body_Lines])
puts ""
puts "Files with Naming: #{total_naming}"
puts "Files with Part of: #{total_partof}"
puts "Files to strip: #{[total_naming, total_partof].max}"
puts "Total identities: #{files.size}"
