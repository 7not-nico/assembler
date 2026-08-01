#!/usr/bin/env ruby
# ring: 1 (DB-READ) — ## Gotchas section present (recommended per PROT.META.PROTOCOL.IDENTITY)
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/schema_db

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/schema_db"

TARGET_TYPE = "protocols"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []

SeedDB.call

files.each do |path|
  text = File.read(path)
  basename = File.basename(path, ".md")
  fm = ParseFrontmatter.call(text)
  next unless fm
  id = fm[:id] || basename

  if text =~ /^---\n.*?\n---\n/m
    body = $~.post_match
  else
    body = text
  end

  unless body =~ /^## Gotchas\b/
    violations << [id, "missing ## Gotchas", "", "add ## Gotchas section (antipattern + redirect)"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 gotchas violations"
else
  puts "protocol gotchas violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
