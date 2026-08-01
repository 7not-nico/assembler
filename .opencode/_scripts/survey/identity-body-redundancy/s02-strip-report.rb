# s02-strip-report.rb — show what will be stripped from each identity body
# ring: 1 (LOCAL-READ)
# depends-on: ../_rb/loader
# non-write: reads .md files, outputs report

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
DIR = ROOT.join(".opencode", "entities", "identities")

puts "=== Identity Body Strip Report ==="
puts ""
puts "Stripping from each identity body:"
puts "  - **Naming:** line -> covered by `naming:` backmatter field"
puts "  - **Part of:** line -> covered by `group:` + `ring:` backmatter fields + SPEC.KNOWLEDGE.CLASSIFICATION"
puts ""
puts "Keeping: **{Title}** - {description} only"
puts ""

total_naming = 0
total_partof = 0

Dir[DIR.join("IDENTITY.*.md")].sort.each do |f|
  text = File.read(f)
  id = File.basename(f, ".md")
  body = text.split(/^---$/)[0].strip
  lines = body.split("\n")

  naming_lines = lines.select { |l| l.start_with?("**Naming:**") }
  partof_lines = lines.select { |l| l.start_with?("**Part of:**") }

  total_naming += naming_lines.size
  total_partof += partof_lines.size

  # Read backmatter
  parts = text.split(/^---$/).reject(&:empty?)
  yml = YAML.safe_load(parts[1].strip) rescue {}

  puts "#{id}"
  puts "  keep:  #{lines.first[0..80]}"
  naming_lines.each { |l| puts "  drop:  #{l[0..80]}" }
  partof_lines.each { |l| puts "  drop:  #{l[0..80]}" }
  puts "  bm:    group=#{yml["group"].inspect}  ring=#{yml["ring"].inspect}  naming=#{yml["naming"].inspect}"
  puts ""
end

puts "==="
puts "Lines to strip: #{total_naming} naming + #{total_partof} part-of = #{total_naming + total_partof}"
puts "Result: 15 single-line identity bodies (description only)"
