#!/usr/bin/env ruby
# ring: N (RING_NAME) — short descriptor
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
  fm = ParseFrontmatter.call(text)
  next unless fm

  # validate condition
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 violations"
else
  puts "violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Field Value])
end
