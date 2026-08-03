#!/usr/bin/env ruby
# ring: 1 (DB-READ) — enforcement field is Tool, Convention, or Review
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/schema_db

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/schema_db"

TARGET_TYPE = "protocols"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []
VALID = %w[Sealed Accord Formality]

SeedDB.call

files.each do |path|
  text = File.read(path)
  basename = File.basename(path, ".md")
  fm = ParseFrontmatter.call(text)
  next unless fm
  id = fm[:id] || basename

  val = fm[:enforcement].to_s.strip
  unless VALID.include?(val)
    violations << [id, "invalid enforcement", val, "must be Sealed, Accord, or Formality"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 enforcement violations"
else
  puts "protocol enforcement violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
