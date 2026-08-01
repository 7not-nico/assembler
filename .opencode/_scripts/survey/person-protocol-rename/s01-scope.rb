#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey scope of PROT.PERSON.ENTITY.SCHEMA → PROT.PERSON.IDENTITY.SCHEMA rename
# survey: person-protocol-rename
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"

OPCODE = ROOT.join(".opencode")
SKIP_DIRS = %w[reports _backups]

OLD_ID = "PROT.PERSON.ENTITY.SCHEMA"
NEW_ID = "PROT.PERSON.IDENTITY.SCHEMA"

hits = []

Dir[OPCODE.join("**", "*.md")].sort.each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  next if SKIP_DIRS.any? { |d| rel.start_with?(".opencode/#{d}") }

  text = File.read(path)
  next unless text.include?(OLD_ID)

  lines = text.split("\n")
  lines.each_with_index do |line, idx|
    next unless line.include?(OLD_ID)
    hits << [rel, (idx + 1).to_s, line.strip[0..90]]
  end
end

# Also check scripts
Dir[ROOT.join("scripts", "**", "*.rb")].sort.each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  text = File.read(path)
  next unless text.include?(OLD_ID)

  lines = text.split("\n")
  lines.each_with_index do |line, idx|
    next unless line.include?(OLD_ID)
    hits << [rel, (idx + 1).to_s, line.strip[0..90]]
  end
end

puts "=== Protocol Rename: #{OLD_ID} → #{NEW_ID} ==="
puts ""

if hits.empty?
  puts "No references found — rename already complete."
else
  puts "References to rename (#{hits.size}):"
  puts Table.call(hits, %w[File Line Context])
  puts ""

  # Group by file
  file_counts = hits.map { |r| r[0] }.tally
  puts "Files affected: #{file_counts.size}"

  # Check DB state
  db_path = ROOT.join(".opencode", "patlib.db")
  if File.exist?(db_path)
    db_id = `sqlite3 #{db_path} "SELECT id FROM protocols WHERE id LIKE '%PERSON%ENTITY%' OR id LIKE '%PERSON%IDENTITY%' LIMIT 1" 2>/dev/null`.strip
    if db_id.empty?
      puts "DB: no matching entry found (may already use NEW_ID or be absent)"
    elsif db_id == NEW_ID
      puts "DB: already #{NEW_ID} ✓"
    else
      puts "DB: currently '#{db_id}' — needs sync"
    end
  end
end
