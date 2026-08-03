#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — no spacing artifacts in junction lines
# depends-on: _rb/paths, _rb/frontmatter, _rb/body, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/body"
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

  cat_lines = ExtractCatSection.call(text)
  cat_lines.each_with_index do |line, idx|
    if line.start_with?("-")
      # Check for double space after dash
      if line =~ /^-\s\s/
        violations << [id, "double space after `-`", line[0..50], "use single space: `- `"]
      end
      # Check for no space after dash
      if line =~ /^-[^ -]/
        violations << [id, "missing space after `-`", line[0..50], "add space: `- `"]
      end
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 spacing violations"
else
  puts "maxim spacing violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
