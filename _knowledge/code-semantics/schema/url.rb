#!/usr/bin/env ruby
require 'yaml'
require 'set'
require 'sqlite3'

SRC_DIR  = File.join(__dir__, '..', 'semantic')
DB_PATH  = File.join(__dir__, 'semantics.db')
OUT_PATH = File.join(__dir__, 'url.sql')

# Collect URLs from role files
rows = []
Dir.glob(File.join(SRC_DIR, '*-{subject,object,action}.md')).each do |fp|
  content = File.read(fp)
  next unless content =~ /\A---\s*\n(.*?\n)---\s*\n/m
  meta = YAML.safe_load($1, permitted_classes: [Array]) rescue next
  next unless meta && meta['id'] && meta['sources']

  meta['sources'].each do |src|
    next unless src['section'] && src['url']
    rows << { language: meta['language'], section: src['section'], url: src['url'], role: meta['id'] }
  end
end

# Deduplicate
url_map = {}
rows.each do |r|
  url_map[r[:url]] ||= { language: r[:language], section: r[:section], roles: Set.new }
  url_map[r[:url]][:roles] << r[:role]
end

# Write url.sql
sorted = url_map.sort_by { |url, _| url }
lines = []
lines << "-- PROT.FRONTMATTER.ROLE.FILE — Seed: reference URLs"
lines << "-- Re-generate: ruby schema/url.rb"
lines << ""
lines << "INSERT OR IGNORE INTO reference_urls (language, section, url, roles) VALUES"

values = sorted.map do |url, info|
  roles_str = info[:roles].to_a.sort.join(', ')
  lang_esc  = info[:language].gsub("'", "''")
  sec_esc   = info[:section].gsub("'", "''")
  url_esc   = url.gsub("'", "''")
  "  ('#{lang_esc}', '#{sec_esc}', '#{url_esc}', '#{roles_str}')"
end
lines << values.join(",\n") + ";"

File.write(OUT_PATH, lines.join("\n") + "\n")
puts "  SQL  #{OUT_PATH}  (#{url_map.size} rows)"

# Push into semantics.db
db = SQLite3::Database.new(DB_PATH)
db.execute("CREATE TABLE IF NOT EXISTS reference_urls (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  language TEXT NOT NULL,
  section TEXT NOT NULL,
  url TEXT NOT NULL UNIQUE,
  roles TEXT
)")
sorted.each do |url, info|
  roles_str = info[:roles].to_a.sort.join(', ')
  db.execute("INSERT OR IGNORE INTO reference_urls (language, section, url, roles) VALUES (?, ?, ?, ?)",
    [info[:language], info[:section], url, roles_str])
end
puts "  DB   #{DB_PATH}  (#{db.execute('SELECT COUNT(*) FROM reference_urls').flatten.first} rows)"
