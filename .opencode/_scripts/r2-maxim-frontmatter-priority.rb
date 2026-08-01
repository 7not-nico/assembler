#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — priority is integer 1-5
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

  p = fm[:priority]
  unless p.is_a?(Integer) && p >= 1 && p <= 5
    violations << [id, "priority out of range", p.to_s, "must be integer 1-5"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 priority violations"
else
  puts "maxim priority violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
