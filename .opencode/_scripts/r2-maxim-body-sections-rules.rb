#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — ## Rules section exists
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

  if text =~ /^---\n.*?\n---\n/m
    body = $'
  else
    body = text
  end
  unless body =~ /^## Rules\b/
    violations << [id, "missing ## Rules", "", "add ## Rules section"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 rules section violations"
else
  puts "maxim rules section violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
