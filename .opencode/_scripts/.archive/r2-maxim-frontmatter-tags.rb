#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — tags has minimum 3 entries
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

  tags = fm[:tags]
  unless tags.is_a?(Array) && tags.size >= 3
    count = tags.is_a?(Array) ? tags.size.to_s : "not array"
    violations << [id, "tags < 3", count, "minimum 3 tags required"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 tag violations"
else
  puts "maxim tag violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
