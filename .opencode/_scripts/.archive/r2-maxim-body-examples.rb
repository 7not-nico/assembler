#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — no concrete named examples in maxim body
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

  # Skip frontmatter
  if text =~ /^---\n.*?\n---\n/m
    body = $'
  else
    body = text
  end

  # Check for file paths (concrete examples)
  body.each_line.with_index(1) do |line, lineno|
    next if line.strip.empty?
    next if line =~ /^## /  # skip headers
    next if line =~ /^\s*$/ # blank
    next if line =~ /^\s*- / # junction lines are structural

    # Flag lines with concrete file paths
    if line =~ %r{[./]opencode/[./]}
      violations << [id, "concrete path", line.strip[0..50], "extract to illustration"]
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 example violations"
else
  puts "maxim example violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
