#!/usr/bin/env ruby
# push-registry.rb — register _templates/ artifacts into templates.db
# Layer: script/ — Ruby loader targets schema tables
# Usage: ruby script/push-registry.rb
require 'sqlite3'
require 'json'
require 'pathname'

DB_PATH = File.join(__dir__, '..', 'schema', 'templates.db')
TPL_DIR = File.join(__dir__, '..')
db      = SQLite3::Database.new(DB_PATH)

# Additive migration: ensure new columns exist on pre-existing tables BEFORE schema
# batch (which creates indexes on them)
begin
  db.execute("ALTER TABLE templates ADD COLUMN chain_pos INTEGER")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE templates ADD COLUMN tags TEXT")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE templates ADD COLUMN composes TEXT")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE templates ADD COLUMN governs TEXT")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE templates ADD COLUMN input TEXT")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE templates ADD COLUMN output TEXT")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE reports ADD COLUMN date TEXT")
rescue SQLite3::SQLException; end
begin
  db.execute("ALTER TABLE reports ADD COLUMN error_text TEXT")
rescue SQLite3::SQLException; end

# Ensure schema exists (additive — ALTER for new columns on existing DB)
schema = File.read(File.join(__dir__, '..', 'schema', 'templates.sql'))
db.execute_batch(schema)

# Chain position lookup — layer name → chain order (1..13); infra = nil
CHAIN = {
  'format/' => 1, 'precept/' => 2, 'procedure/' => 3, 'research/' => 4,
  'concept/' => 5, 'note/' => 6, 'bitacora/' => 7, 'glossary/' => 8,
  'schema/' => 9, 'script/' => 10, 'reference/' => 11, 'fixtures/' => 12,
  'practice/' => 13
}

count = 0

# Templates: *-template.md files at root of _templates/
Dir.glob(File.join(TPL_DIR, '*-template.md')).each do |fp|
  name    = File.basename(fp)
  content = File.read(fp)
  layer   = (content[/^\*\*Layer:\*\*\s*(.+)$/, 1] || 'bootstrap').strip.split(' ').first
  purpose = content[/^\*\*Purpose:\*\*\s*(.+)$/, 1]&.strip ||
            content[/^# (.+)$/, 1]&.strip || name
  chain_pos = CHAIN[layer]

  # tags: top-level ## headings + key terms in purpose (discriminative keywords)
  headings = content.scan(/^## (.+)$/).flatten.map(&:strip)
  purpose_words = purpose.to_s.downcase.gsub(/[^a-z0-9\s]/, '').split.reject { |w| w.length < 4 }
  tags = (headings + purpose_words).uniq.first(12)

  # composes: "Composes with:" references from header (precept/procedure links)
  composes = []
  comp_sec = content[/^\*\*Composes with:\*\*\s*(.*)$/, 1]
  if comp_sec
    composes = comp_sec.scan(/`([^`]+)`/).flatten.map(&:strip)
  end

  # governs: ## Governs section bullet list
  governs = []
  if content =~ /^## Governs\s*$/
    gpart = content.split(/^## Governs\s*$/)[1].to_s.split(/^## /)[0]
    governs = gpart.scan(/`([^`]+)`/).flatten.map(&:strip)
  end

  # input/output: first ## section names as weak signal (Prerequisites → input, Steps/Verify → output)
  input = content[/^## (Prerequisites|Prerequisite)\s*$/, 1] ? 'prerequisites' : nil
  output = content[/^## (Steps|Verify)\s*$/, 1] ? content[/^## (Steps|Verify)\s*$/, 1] : nil

  db.execute(
    'INSERT INTO templates (id, layer, purpose, file_path, kind, chain_pos, tags, composes, governs, input, output)
     VALUES (?,?,?,?,?,?,?,?,?,?,?)
     ON CONFLICT(id) DO UPDATE SET layer=excluded.layer, purpose=excluded.purpose,
     chain_pos=excluded.chain_pos, tags=excluded.tags, composes=excluded.composes,
     governs=excluded.governs, input=excluded.input, output=excluded.output,
     updated=datetime(\'now\')',
    [name, layer, purpose, File.join('_templates', name), 'template', chain_pos,
     tags.to_json, composes.to_json, governs.to_json, input, output]
  )
  puts "  TPL #{name} [#{layer} pos=#{chain_pos.inspect} tags=#{tags.length} comp=#{composes.length}]"
  count += 1
end

# Reports: session reports
icount = 0
Dir.glob(File.join(TPL_DIR, 'reports', '*.md')).each do |fp|
  next if File.basename(fp) == 'report-template.md'
  name    = File.basename(fp)
  content = File.read(fp)
  project = content[/^\*\*Project:\*\*\s*(.+)$/, 1]&.strip
  date    = content[/^\*\*Date:\*\*\s*(.+)$/, 1]&.strip
  # count numbered items only within Errors / Findings sections — heading-line anchored,
  # so mid-line mentions of "## Findings" inside code blocks don't split early
  err_sec = content.split(/^## Errors found\s*$/)[1].to_s.split(/^## Findings\s*$/)[0].to_s
  fin_sec = content.split(/^## Findings\s*$/)[1].to_s.split(/^## Open edges\s*$/)[0].to_s
  errors  = err_sec.scan(/^\d+\. /).length
  findings = fin_sec.scan(/^\d+\. /).length
  # error_text: first clause of each numbered error (after the "→" fix marker)
  error_text = err_sec.scan(/^\d+\.\s*(.+?)(?:\s*→|\n)/m).flatten.map { |e| e.strip.split('—').first }.join(' | ')[0, 500]

  db.execute(
    'INSERT INTO reports (id, project, date, errors, findings, error_text, file_path) VALUES (?,?,?,?,?,?,?)
     ON CONFLICT(id) DO UPDATE SET project=excluded.project, date=excluded.date,
     errors=excluded.errors, findings=excluded.findings, error_text=excluded.error_text,
     created=datetime(\'now\')',
    [name, project, date, errors, findings, error_text, File.join('_templates', 'reports', name)]
  )
  puts "  INF #{name} (#{project}, #{date}, #{errors} err, #{findings} find)"
  icount += 1
end

puts "Pushed #{count} templates, #{icount} reports into #{DB_PATH}"
