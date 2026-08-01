#!/usr/bin/env ruby
# push-registry.rb — push glossary terms + notes into hypr registry DB
# Layer: script/ — Ruby loader targets schema tables
# Usage: ruby script/push-registry.rb
require 'sqlite3'
require 'pathname'

DB_PATH = File.join(__dir__, '..', 'schema', 'hypr.db')
GLOSS_DIR = File.join(__dir__, '..', 'glossary')
NOTE_DIR  = File.join(__dir__, '..', 'note')
db        = SQLite3::Database.new(DB_PATH)

# Ensure schema exists
schema = File.read(File.join(__dir__, '..', 'schema', 'hypr.sql'))
db.execute_batch(schema)

count = 0
Dir.glob(File.join(GLOSS_DIR, '*.md')).each do |fp|
  term       = File.basename(fp, '.md')   # filename is authoritative
  content    = File.read(fp)
  definition = content.lines[1..].join.strip

  # Extract related terms from "## Related" section
  related = []
  if definition =~ /## Related\n(.*?)(?:\n## |\z)/m
    related = $1.scan(/\{([^}]+)\}/).flatten.map(&:strip)
  end

  db.execute(
    'INSERT INTO glossary (term, definition, related, source) VALUES (?,?,?,?)
     ON CONFLICT(term) DO UPDATE SET definition=excluded.definition, related=excluded.related, updated=datetime(\'now\')',
    [term, definition, related.empty? ? nil : related.to_json, File.basename(fp)]
  )
  puts "  OK  #{term}"
  count += 1
end

ncount = 0
Dir.glob(File.join(NOTE_DIR, 'ch*.md')).each do |fp|
  id      = File.basename(fp, '.md')
  chapter = id[/ch(\d+)/, 1].to_i
  title   = id.sub(/^ch\d+-/, '').gsub('-', ' ').capitalize
  source  = File.readlines(fp).find { |l| l =~ /^\*\*Source:\*\*/ }&.sub(/^\*\*Source:\*\*\s*/, '')&.strip

  db.execute(
    'INSERT INTO notes (id, title, source, chapter) VALUES (?,?,?,?)
     ON CONFLICT(id) DO UPDATE SET title=excluded.title, source=excluded.source, chapter=excluded.chapter',
    [id, title, source, chapter]
  )
  puts "  NOTE #{id} (ch#{chapter})"
  ncount += 1
end

puts "Pushed #{count} terms, #{ncount} notes into #{DB_PATH}"
