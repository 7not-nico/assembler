# s01-inventory.rb — list each identity's current body structure
# ring: 1 (LOCAL-READ)
# depends-on: ../_rb/loader
# non-write: reads .md files, outputs table

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
DIR = ROOT.join(".opencode", "entities", "identities")

puts "=== Identity Body Inventory ==="
puts ""

Dir[DIR.join("IDENTITY.*.md")].sort.each do |f|
  text = File.read(f)
  id = File.basename(f, ".md")

  # Extract body: text between start and first ---
  body = text.split(/^---$/)[0].strip
  lines = body.split("\n")

  desc = lines.first
  has_naming = lines.any? { |l| l.start_with?("**Naming:**") }
  has_part_of = lines.any? { |l| l.start_with?("**Part of:**") }
  extra = lines.select { |l| !l.start_with?("**") && !l.strip.empty? && l != desc }
  extra_count = extra.size

  puts "#{id}"
  puts "  description: #{desc[0..80]}..."
  puts "  has_naming: #{has_naming}"
  puts "  has_part_of: #{has_part_of}"
  puts "  extra_body_lines: #{extra_count}"
  puts ""
end

puts "---"
puts "Total: #{Dir[DIR.join("IDENTITY.*.md")].size} identities"
