#!/usr/bin/env ruby
# ring: 6 (DB-WRITE)
# depends-on: _rb/loader, _rb/frontmatter, _rb/patlib, sqlite3, yaml, pathname
# Usage: ruby r6-patlib-sync.rb [--type TABLE] [--dry]

require_relative "_rb/loader"
require_relative "_rb/frontmatter"
require_relative "_rb/patlib"
require_relative "_rb/paths"
require "sqlite3"
require "yaml"
require "pathname"
require "json"

Root = ROOT
DbPath = Root.join(".opencode", "patlib.db").to_s
EntityDir = Root.join(".opencode", "entities").to_s
RuleYaml = Root.join(".opencode", "rules", "yamls").to_s
RuleDoc = Root.join(".opencode", "rules").to_s
CommandYaml = Root.join(".opencode", "commands", "yamls").to_s
SkillDir = Root.join(".opencode", "skills").to_s

ArgvType = ARGV.include?("--type") ? ARGV[ARGV.index("--type") + 1] : nil
Dry = ARGV.include?("--dry")

# ── Pure lambdas ──

frontExtractor = ->(text) { (match = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)) ? match.post_match.strip : text.strip }
backExtractor = ->(text) { (match = text.match(/---\s*\n(.*?)\n---\s*\z/m)) ? match.pre_match.strip : text.strip }
stamper = ->(value) { value.nil? ? Time.now.utc.iso8601 : value.to_s }
csvConverter = ->(value) { value.nil? ? nil : (value.is_a?(Array) ? value.map(&:to_s).join(",") : value.to_s) }
refConverter = ->(value) {
  return nil if value.nil?
  url = value.map { |entry| entry.is_a?(Hash) && entry[:url] ? entry[:url].to_s : entry.to_s }
  url.to_json
}
splitter = ->(value) { value.nil? ? [] : (value.is_a?(Array) ? value.map(&:to_s) : value.to_s.split(",").map(&:strip)) }

parserBuilder = ->(meta, body) {
  ->(text) {
    entry = meta.call(text)
    entry ? entry.merge(body: body.call(text), created: stamper.call(entry[:created]), modified: stamper.call(entry[:modified])) : nil
  }
}

frontParser = parserBuilder.call(ParseFrontmatter, frontExtractor)
backParser = parserBuilder.call(ParseBackmatter, backExtractor)

# ── Table configs: [table, subdir, parser, columns, junction_type] ──

CommonRef = %w[id title body source related tags reference created modified]

Config = [
  ["patterns", "patterns", frontParser, %w[id title body source summary principle enforcement status priority tags created modified], "pattern"],
  ["maxims", "maxims", frontParser, %w[id title body source summary principle enforcement status priority tags related created modified], nil],
  ["precepts", "precepts", frontParser, %w[id title body source summary precept enforcement status priority tags related created modified], nil],
  ["protocols", "protocols", frontParser, %w[id title body source protocol enforcement status priority tags related created modified], "protocol"],
  ["refs", "references", frontParser, %w[id title body source ref_text tags related created modified], "ref"],
  ["nexus", "nexus", frontParser, %w[id title body source summary nexus composition status priority tags related created modified], nil],
  ["illustrations", "illustrations", frontParser, %w[id title body source summary illustration illustrates related tags created modified], nil],
  ["apologias", "apologias", frontParser, %w[id title body source tags related created modified], nil],
  ["persons", "persons", frontParser, %w[id title body subtype source tags created modified], nil],
  ["terms", "terms", backParser, CommonRef, "term"],
  ["bio", "biology", backParser, CommonRef, nil],
  ["chem", "chemistry", backParser, CommonRef, nil],
  ["cognitions", "cognitions", backParser, CommonRef, nil],
  ["concepts", "concepts", backParser, CommonRef, nil],
  ["definitions", "definitions", backParser, CommonRef, nil],
  ["identities", "identities", backParser, CommonRef, nil],
  ["abstractions", "abstractions", backParser, CommonRef, nil],
  ["linguistics", "linguistics", backParser, CommonRef, nil],
  ["taxonomy", "taxonomies", backParser, %w[id title body source rank precedes related tags reference created modified], nil],
  ["ml", "machine-learning", backParser, %w[id title body source type paradigm subfield category precedes related tags reference created modified], nil],
  ["bash", "bash", backParser, %w[id title body source precedes related tags reference created modified], nil],
  ["ruby", "ruby", backParser, %w[id title body source precedes related tags reference created modified], nil],
  ["specifications", "specifications", backParser, %w[id title body source summary related tags reference created modified], nil],
  ["manifests", "manifests", backParser, %w[id title body source tags related created modified], nil],
]

normalizer = ->(key, value) {
  case key
  when :reference then refConverter.call(value)
  when :tags, :related, :precedes, :terms, :patterns, :illustrates then csvConverter.call(value)
  else value
  end
}

junctionSyncer = ->(db, type, id, terms, patterns) {
  db.execute("DELETE FROM entity_terms WHERE source_type = ? AND source_id = ?", [type, id])
  db.execute("DELETE FROM entity_patterns WHERE source_type = ? AND source_id = ?", [type, id])
  splitter.call(terms).each { |term| db.execute("INSERT OR IGNORE INTO entity_terms (source_type, source_id, term_id) VALUES (?, ?, ?)", [type, id, term]) }
  splitter.call(patterns).each { |pattern| db.execute("INSERT OR IGNORE INTO entity_patterns (source_type, source_id, pattern_id) VALUES (?, ?, ?)", [type, id, pattern]) }
}

illustrationSyncer = ->(db, id, illustrates) {
  db.execute("DELETE FROM illustration_entities WHERE illustration_id = ?", [id])
  splitter.call(illustrates).each do |entry|
    type = PrefixToType[entry.split(".").first]
    db.execute("INSERT INTO illustration_entities (illustration_id, entity_id, entity_type) VALUES (?, ?, ?)", [id, entry, type]) if type
  end
}

tableSyncer = ->(db, config) {
  table, subdir, parser, col, junction = config
  dir = File.join(EntityDir, subdir)
  file = Dir.glob(File.join(dir, "*.md")).sort
  return 0 if file.empty?

  column = col.join(", ")
  marker = col.map { "?" }.join(", ")
  conflict = col.reject { |col| col == "id" || col == "created" }
  set = conflict.map { |col| "#{col} = ?" }.join(", ")
  sql = "INSERT INTO #{table} (#{column}) VALUES (#{marker}) ON CONFLICT(id) DO UPDATE SET #{set}"

  count = 0
  list = []
  file.each do |path|
    data = parser.call(File.read(path))
    next unless data
    list << data[:id].to_s
    value = col.map { |col| normalizer.call(col.to_sym, data[col.to_sym]) }
    db.execute(sql, value + conflict.map { |col| normalizer.call(col.to_sym, data[col.to_sym]) })
    junctionSyncer.call(db, junction, data[:id], data[:terms], data[:patterns]) if junction
    illustrationSyncer.call(db, data[:id], data[:illustrates]) if table == "illustrations"
    count += 1
  end

  # Cleanup keys on parsed frontmatter ids — filenames may differ (e.g. per-acm.md → PER.ACM)
  unless list.empty?
    marker = list.map { "?" }.join(",")
    db.execute("DELETE FROM #{table} WHERE id NOT IN (#{marker})", list)
  end
  count
}

# ── Rules, commands, skills (yaml / SKILL.md sources) ──

ruleSyncer = ->(db) {
  file = Dir.glob(File.join(RuleYaml, "*.yaml")).sort
  count = 0
  list = []
  file.each do |path|
    yaml = YAML.safe_load(File.read(path), permitted_classes: [Date, Time], symbolize_names: true) || {}
    id = yaml[:id].to_s
    next if id.empty?
    list << id
    doc = File.join(RuleDoc, File.basename(path, ".yaml") + ".md")
    body = File.exist?(doc) ? File.read(doc).strip : nil
    db.execute(
      "INSERT INTO rules (id, title, source, tags, related, body, created, modified) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
       ON CONFLICT(id) DO UPDATE SET title = ?, source = ?, tags = ?, related = ?, body = ?, modified = ?",
      [id, yaml[:title].to_s, yaml[:source]&.to_s, csvConverter.call(yaml[:tags]), csvConverter.call(yaml[:related]), body, stamper.call(yaml[:created]), stamper.call(yaml[:modified]),
       yaml[:title].to_s, yaml[:source]&.to_s, csvConverter.call(yaml[:tags]), csvConverter.call(yaml[:related]), body, stamper.call(yaml[:modified])]
    )
    junctionSyncer.call(db, "rule", id, yaml[:terms], yaml[:patterns])
    count += 1
  end
  unless list.empty?
    marker = list.map { "?" }.join(",")
    db.execute("DELETE FROM rules WHERE id NOT IN (#{marker})", list)
  end
  count
}

commandSyncer = ->(db) {
  file = Dir.glob(File.join(CommandYaml, "*.yaml")).sort
  count = 0
  list = []
  file.each do |path|
    yaml = YAML.safe_load(File.read(path), permitted_classes: [Date, Time], symbolize_names: true) || {}
    id = yaml[:id].to_s
    next if id.empty?
    list << id
    db.execute(
      "INSERT INTO commands (id, title, description, source, tags, related, created, modified) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
       ON CONFLICT(id) DO UPDATE SET title = ?, description = ?, source = ?, tags = ?, related = ?, modified = ?",
      [id, yaml[:title].to_s, yaml[:description]&.to_s, yaml[:source]&.to_s, csvConverter.call(yaml[:tags]), csvConverter.call(yaml[:related]), stamper.call(yaml[:created]), stamper.call(yaml[:modified]),
       yaml[:title].to_s, yaml[:description]&.to_s, yaml[:source]&.to_s, csvConverter.call(yaml[:tags]), csvConverter.call(yaml[:related]), stamper.call(yaml[:modified])]
    )
    junctionSyncer.call(db, "command", id, yaml[:terms], yaml[:patterns])
    count += 1
  end
  unless list.empty?
    marker = list.map { "?" }.join(",")
    db.execute("DELETE FROM commands WHERE id NOT IN (#{marker})", list)
  end
  count
}

BoldRe = /^\*\*([^*]+)\*\*\s*(?:—\s*)?/m
Known = %w[Trigger Procedure Gotchas Rules]

skillSyncer = ->(db) {
  path = Dir.glob(File.join(SkillDir, "*", "SKILL.md")).sort
  count = 0
  list = []
  path.each do |file|
    text = File.read(file)
    meta = ParseFrontmatter.call(text)
    next unless meta
    name = meta[:name].to_s
    next if name.empty?
    id = "SKL." + name.upcase.gsub("-", ".")
    list << id
    title = name.split("-").map(&:capitalize).join(" ")
    body = frontExtractor.call(text)
    chunk = body.split(BoldRe)
    chunk.shift
    section = {}
    chunk.each_slice(2) { |header, content| section[header.strip] = (content || "").strip }
    extra = section.reject { |key, _| Known.include?(key) }.map { |key, value| "## #{key}\n#{value}" }.join("\n\n")
    db.execute(
      "INSERT INTO skills (id, title, description, trigger, procedure, gotchas, rules, body, skill, state_profile, related)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
       ON CONFLICT(id) DO UPDATE SET title = ?, description = ?, trigger = ?, procedure = ?, gotchas = ?, rules = ?, body = ?, skill = ?, state_profile = ?, related = ?",
      [id, title, meta[:description].to_s, section["Trigger"], section["Procedure"], section["Gotchas"], section["Rules"], extra.empty? ? nil : extra, name, meta[:"state-profile"]&.to_s, csvConverter.call(meta[:related]),
       title, meta[:description].to_s, section["Trigger"], section["Procedure"], section["Gotchas"], section["Rules"], extra.empty? ? nil : extra, name, meta[:"state-profile"]&.to_s, csvConverter.call(meta[:related])]
    )
    junctionSyncer.call(db, "skill", id, meta[:terms], meta[:patterns])
    count += 1
  end
  unless list.empty?
    marker = list.map { "?" }.join(",")
    db.execute("DELETE FROM skills WHERE id NOT IN (#{marker})", list)
  end
  count
}

# ── Pipeline ──

db = SQLite3::Database.new(DbPath)
db.execute("PRAGMA busy_timeout = 5000")
report = []

all = Config.map { |config| config[0] } + %w[rules commands skills]
target = ArgvType ? (ArgvType == "all" ? all : [ArgvType]) : all

if Dry
  puts "dry-run: would sync #{target.join(", ")}"
  target.each { |name| puts "  #{name}" }
  exit 0
end

db.transaction do
  Config.each do |config|
    next unless target.include?(config[0])
    report << "#{tableSyncer.call(db, config)} #{config[0]}"
  end
  report << "#{ruleSyncer.call(db)} rules" if target.include?("rules")
  report << "#{commandSyncer.call(db)} commands" if target.include?("commands")
  report << "#{skillSyncer.call(db)} skills" if target.include?("skills")
end

db.close
puts "Synced #{report.join(", ")}."
