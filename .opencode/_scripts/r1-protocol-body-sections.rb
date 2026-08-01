#!/usr/bin/env ruby
# ring: 1 (DB-READ) — ## Protocol, ## Enforcement, ## Applicability, ## See also exist
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/schema_db

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/schema_db"

TARGET_TYPE = "protocols"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []

REQUIRED = ["## Protocol", "## Enforcement", "## Applicability", "## See also"]

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

  REQUIRED.each do |section|
    unless body =~ /^#{Regexp.escape(section)}\b/
      violations << [id, "missing #{section}", "", "add #{section} section"]
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 body section violations"
else
  puts "protocol body section violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
