#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — no "composes with" language in maxim body (per PROT.MAXIM.IDENTITY:12)
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

  body.each_line.with_index(1) do |line, lineno|
    next if line =~ /^## /  # skip ## See also for navigation links
    next if line.strip.empty?

    # Flag "Composes with" language (case-insensitive), but not entity composition descriptions
    next if line =~ /composition direction/i
    next if line =~ /comp\w*s with\b.*entity/i
    if line =~ /\bcomp\w*s with\b/i
      violations << [id, "composes with", line.strip[0..50], "maxims are orthogonal; remove"]
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 compose violations"
else
  puts "maxim compose violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
