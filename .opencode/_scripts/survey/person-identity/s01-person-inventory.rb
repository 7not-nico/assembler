#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — inventory of all person entities
# survey: person-identity
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"
require_relative "../../_rb/rings"

PERSONS_DIR = ENTITIES.join("persons")
DB_PATH = ROOT.join("patlib.db")

rows = []
Dir[EntityGlob.call("persons")].sort.each do |path|
  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  id = fm[:id] || File.basename(path, ".md")
  body = text.sub(/\A---\s*\n.*?\n---\s*\n/m, "").strip
  body_len = body.length

  tags = fm[:tags].is_a?(Array) ? fm[:tags].join(", ") : fm[:tags].to_s

  rows << [
    id,
    fm[:title].to_s,
    fm[:subtype].to_s,
    fm[:source].to_s,
    tags,
    body_len.to_s
  ]
end

puts "=== Person Inventory ==="
puts ""
puts Table.call(rows, %w[ID Title Subtype Source Tags BodyLen])

puts ""

# Summary
physical = rows.count { |r| r[2] == "physical" }
jurisdictional = rows.count { |r| r[2] == "jurisdictional" }
sources = rows.map { |r| r[3] }.tally

puts "Summary:"
puts "  total: #{rows.size}"
puts "  physical: #{physical}"
puts "  jurisdictional: #{jurisdictional}"

puts ""
puts "Sources:"
sources.sort_by { |_, v| -v }.each do |src, count|
  puts "  #{src}: #{count}"
end

# DB cross-ref for event counts
if File.exist?(DB_PATH)
  events_by_person = `sqlite3 #{DB_PATH} "SELECT person_id, COUNT(*) FROM person_events GROUP BY person_id" 2>/dev/null`.strip.lines
  event_map = events_by_person.each_with_object({}) do |line, h|
    pid, cnt = line.split("|")
    h[pid] = cnt.to_i
  end

  no_events = rows.select { |r| event_map[r[0]].to_i == 0 }.map { |r| r[0] }
  unless no_events.empty?
    puts ""
    puts "Persons with no events in DB:"
    no_events.each { |id| puts "  #{id}" }
  end

  total_events = event_map.values.sum
  puts ""
  puts "Events: #{total_events} total across #{event_map.size} persons"
end
