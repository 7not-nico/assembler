#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey scope of REF.META.ENTITY.ROUTING → SPEC.ENTITY.ROUTING.TABLE migration
# survey: routing-table-migration
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
OPCODE = ROOT.join(".opencode")
SKIP_DIRS = %w[reports _backups]
OLD_ID = "REF.META.ENTITY.ROUTING"
NEW_ID = "SPEC.ENTITY.ROUTING.TABLE"

hits = []

Dir[OPCODE.join("**", "*.md")].sort.each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  next if SKIP_DIRS.any? { |d| rel.start_with?(".opencode/#{d}") }

  text = File.read(path)
  next unless text.include?(OLD_ID)

  lines = text.split("\n")
  lines.each_with_index do |line, idx|
    next unless line.include?(OLD_ID)
    lines_after = lines[idx..[idx + 2, lines.size - 1].min].map(&:strip)
    hits << [rel, (idx + 1).to_s, lines_after.first(2).join(" ")[0..90]]
  end
end

# Also check skills
Dir[OPCODE.join("skills", "**", "SKILL.md")].sort.each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  text = File.read(path)
  next unless text.include?(OLD_ID)
  lines = text.split("\n")
  lines.each_with_index do |line, idx|
    next unless line.include?(OLD_ID)
    hits << [rel, (idx + 1).to_s, line.strip[0..90]]
  end
end

# Check scripts
Dir[ROOT.join("_scripts", "**", "*.rb")].sort.each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  text = File.read(path)
  next unless text.include?(OLD_ID)
  lines = text.split("\n")
  lines.each_with_index do |line, idx|
    next unless line.include?(OLD_ID)
    hits << [rel, (idx + 1).to_s, line.strip[0..90]]
  end
end

puts "=== REF.META.ENTITY.ROUTING → SPEC.ENTITY.ROUTING.TABLE ==="
puts ""

if hits.empty?
  puts "No references found — migration already complete."
else
  # Group by file
  file_groups = hits.group_by { |r| r[0] }
  puts "Total references: #{hits.size}"
  puts "Source files affected: #{file_groups.size}"
  puts ""
  puts Table.call(hits, %w[File Line Context])
  puts ""

  puts "=== Per-file breakdown ==="
  file_groups.sort.each do |file, refs|
    ref_types = refs.map { |r| r[2].include?("related:") ? "related" : r[2].include?("See also") ? "see-also" : r[2].include?("source:") ? "source" : r[2].include?("illustrates:") ? "illustrates" : r[2].include?("reference:") ? "reference" : r[2].include?("id:") ? "id" : "body" }.uniq
    puts "  #{file} (#{refs.size} refs: #{ref_types.join(', ')})"
  end
  puts ""

  # Check DB state
  db_path = OPCODE.join("patlib.db")
  if File.exist?(db_path)
    db_ref = `sqlite3 #{db_path} "SELECT id FROM refs WHERE id = '#{OLD_ID}' LIMIT 1" 2>/dev/null`.strip
    db_spec = `sqlite3 #{db_path} "SELECT id FROM specifications WHERE id = '#{NEW_ID}' LIMIT 1" 2>/dev/null`.strip
    puts "DB: REF.META.ENTITY.ROUTING in refs table: #{db_ref.empty? ? 'not found ✓' : 'EXISTS — needs cleanup'}"
    puts "DB: SPEC.ENTITY.ROUTING.TABLE in specifications table: #{db_spec.empty? ? 'not yet (will be created)' : 'EXISTS ✓'}"
  end

  puts ""
  puts "=== Recommended steps ==="
  puts "1. Create SPEC.ENTITY.ROUTING.TABLE (Axiomatic R0)"
  puts "2. Delete REF.META.ENTITY.ROUTING"
  puts "3. Update #{hits.size} cross-references in #{file_groups.size} files"
  puts "4. Sync DB: write-sync specifications + refs"
  puts "5. Re-run this survey to verify 0 stale refs"
end
