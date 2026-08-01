#!/usr/bin/env ruby
# seed glossary.db from glossary/*.md files
# functional Ruby per code conventions

require 'sqlite3'

root = File.dirname(__dir__)
path = File.join(root, 'glossary.db')
schemapath = File.join(root, 'schema', 'glossary.sql')

database = SQLite3::Database.new(path)
database.execute(File.read(schemapath))

chapter = {
  'ownership' => 'ch4', 'move' => 'ch4', 'clone' => 'ch4', 'copy' => 'ch4',
  'reference' => 'ch4', 'mutable-reference' => 'ch4', 'slice' => 'ch4',
  'struct' => 'ch5',
  'enum' => 'ch6', 'option' => 'ch6', 'match' => 'ch6',
  'crate' => 'ch7', 'package' => 'ch7', 'module' => 'ch7',
  'visibility' => 'ch7', 'use' => 'ch7',
  'vec' => 'ch8', 'hashmap' => 'ch8', 'string' => 'ch8',
  'panic' => 'ch9', 'result' => 'ch9',
  'generics' => 'ch10', 'trait' => 'ch10', 'lifetime' => 'ch10',
  'test' => 'ch11',
  'args' => 'ch12',
  'closure' => 'ch13', 'iterator' => 'ch13',
  'release-profile' => 'ch14', 'feature-flag' => 'ch14',
  'box' => 'ch15', 'rc' => 'ch15', 'refcell' => 'ch15',
}

source = {
  'use' => 'https://doc.rust-lang.org/stable/book/ch07-04-bringing-paths-into-scope.html',
}

folder = File.join(root, 'glossary')
count = 0

Dir.glob(File.join(folder, '*.md')).each do |entry|
  term = File.basename(entry, '.md')
  content = File.readlines(entry).first.strip
  ch = chapter[term] || 'unknown'
  src = source[term] || "https://doc.rust-lang.org/stable/book/#{ch}-00.html"

  database.execute(
    'INSERT OR IGNORE INTO glossary (term, definition, chapter, source) VALUES (?, ?, ?, ?)',
    [term, content, ch, src]
  )
  count += 1
end

puts "seeded #{count} terms into #{path}"