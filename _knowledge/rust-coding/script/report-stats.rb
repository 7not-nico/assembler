#!/usr/bin/env ruby
# report project statistics

require 'sqlite3'

root = File.dirname(__dir__)

fixtures = Dir.glob(File.join(root, 'fixtures', '*.rs'))
glossary = Dir.glob(File.join(root, 'glossary', '*.md'))
precepts = Dir.glob(File.join(root, 'precept', '*.md'))
procedures = Dir.glob(File.join(root, 'procedure', '*.md'))
notes = Dir.glob(File.join(root, 'note', '*.md'))
bitacoras = Dir.glob(File.join(root, 'bitacora', '*.md'))

tally = fixtures.sum { |f| File.readlines(f).size }
source = fixtures.sum { |f| File.readlines(f).reject { |l| l.strip.empty? || l.strip.start_with?('//') }.size }

puts "=== project stats ==="
puts "fixtures:   #{fixtures.size} files, #{tally} lines, #{source} code lines"
puts "glossary:   #{glossary.size} terms"
puts "precepts:   #{precepts.size} rules"
puts "procedures: #{procedures.size} workflows"
puts "notes:      #{notes.size} documents"
puts "bitacoras:  #{bitacoras.size} entries"

if File.exist?(File.join(root, 'glossary.db'))
  database = SQLite3::Database.new(File.join(root, 'glossary.db'))
  count = database.get_first_value('SELECT count(*) FROM glossary')
  puts "db terms:   #{count} in glossary.db"
end

puts "\n=== fixture list ==="
fixtures.sort.each do |entry|
  name = File.basename(entry, '.rs')
  lines = File.readlines(entry)
  ref = lines.find { |l| l.start_with?('// source:') }&.sub('// source: ', '')&.strip || 'no source'
  puts "#{name} — #{ref}"
end