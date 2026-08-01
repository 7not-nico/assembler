#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — validate person event compliance per PROT.PERSON.IDENTITY.SCHEMA Rule 3
# survey: person-identity
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"
require "set"

DB_PATH = ROOT.join("patlib.db")

violations = []
event_catalog = []

Dir[EntityGlob.call("persons")].sort.each do |path|
  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  id = fm[:id].to_s
  body = text.sub(/\A---\s*\n.*?\n---\s*\n/m, "").strip

  # Check 1: No events key in frontmatter
  if fm.key?(:events)
    violations << [id, "frontmatter-events", "has 'events:' key", "move to _schemas/seeds/02-events.sql"]
  end

  # Check 2: No "## Events" section header in body
  if body.match?(/^##\s+Events\s*$/m)
    violations << [id, "body-section", "has '## Events' section", "use seed data + person_events junction"]
  end

  event_catalog << id
end

puts "=== Person Events Compliance ==="
puts ""

if violations.empty?
  puts "ok — #{event_catalog.size} persons, 0 inline event violations"
else
  puts "violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Check Detail Redirect])
end

puts ""

# Cross-reference DB for event statistics
if File.exist?(DB_PATH)
  db = "sqlite3 #{DB_PATH}"

  # Persons with no events
  no_events = `#{db} "SELECT p.id FROM persons p LEFT JOIN person_events pe ON pe.person_id = p.id WHERE pe.person_id IS NULL ORDER BY p.id" 2>/dev/null`.strip.lines.map(&:strip)
  unless no_events.empty?
    puts "Persons with no linked events:"
    no_events.each { |id| puts "  #{id}" }
    puts ""
  end

  # Events with no linked persons
  orphaned_events = `#{db} "SELECT e.id FROM events e LEFT JOIN person_events pe ON pe.event_id = e.id WHERE pe.event_id IS NULL ORDER BY e.id" 2>/dev/null`.strip.lines.map(&:strip)
  unless orphaned_events.empty?
    puts "Unused event definitions (no person links):"
    orphaned_events.each { |id| puts "  #{id}" }
    puts ""
  end

  # Event catalog usage
  event_usage = `#{db} "SELECT e.id, e.title, COUNT(pe.person_id) AS cnt FROM events e LEFT JOIN person_events pe ON pe.event_id = e.id GROUP BY e.id ORDER BY cnt DESC" 2>/dev/null`.strip.lines
  usage_rows = event_usage.map { |line|
    eid, title, cnt = line.split("|")
    [eid, title, cnt]
  }
  puts "Event type usage:"
  puts Table.call(usage_rows, %w[Event_ID Title Persons_Linked])
  puts ""

  # Event catalog size
  event_count = `#{db} "SELECT COUNT(*) FROM events" 2>/dev/null`.strip
  link_count = `#{db} "SELECT COUNT(*) FROM person_events" 2>/dev/null`.strip
  puts "Total event definitions: #{event_count}"
  puts "Total person–event links: #{link_count}"
end
