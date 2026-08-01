#!/usr/bin/env ruby
require 'yaml'
require 'sqlite3'
require 'json'
require 'pathname'

DB_PATH  = File.join(__dir__, 'semantics.db')
SRC_DIR  = File.join(__dir__, '..', 'semantic')
db       = SQLite3::Database.new(DB_PATH)

Dir.glob(File.join(SRC_DIR, '*-{subject,object,action}.md')).each do |fp|
  content = File.read(fp)
  next unless content =~ /\A---\s*\n(.*?\n)---\s*\n/m

  begin
    meta = YAML.safe_load($1, permitted_classes: [Array])
  rescue
    puts "  SKIP #{File.basename(fp)}: YAML error"
    next
  end
  next unless meta && meta['id']

  rel = Pathname.new(fp).relative_path_from(Pathname.new(SRC_DIR)).to_s

  db.execute(
    'INSERT INTO roles (id,language,role,title,definition,canonical,tags,status,file_path) VALUES (?,?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET language=excluded.language, role=excluded.role, title=excluded.title, definition=excluded.definition, canonical=excluded.canonical, tags=excluded.tags, status=excluded.status, file_path=excluded.file_path, updated_at=datetime(\'now\')',
    [meta['id'], meta['language'], meta['role'], meta['title'], meta['definition'], meta['canonical'], meta['tags']&.to_json, meta['status'] || 'draft', rel]
  )

  (meta['sources'] || []).each do |src|
    next unless src['section']
    db.execute('INSERT INTO sources (role_id, section, url) VALUES (?,?,?)', [meta['id'], src['section'], src['url']])
  end

  [*meta['precedes']].each do |pid|
    db.execute('INSERT OR IGNORE INTO precedes (role_id, precedes_id) VALUES (?,?)', [meta['id'], pid])
  end

  puts "  OK  #{meta['id']}"
end
