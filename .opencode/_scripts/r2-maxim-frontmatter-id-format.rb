#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — id matches MAX.{SEGMENTS} format
# depends-on: _rb/paths, _rb/frontmatter, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

TARGET_TYPE = "maxims"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []

files.each do |path|
  text = File.read(path)
  basename = File.basename(path, ".md")
  fm = ParseFrontmatter.call(text)
  next unless fm
  id = fm[:id] || basename

  unless id =~ /\AMAX\.[A-Z][A-Z0-9.]*\z/
    violations << [id, "invalid id format", id, "must match MAX.{SEGMENTS}"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 id format violations"
else
  puts "maxim id format violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
