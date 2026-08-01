#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — every categorization line must start with `-`
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
  in_code = false
  cat_lines.each_with_index do |line, idx|
    in_code = !in_code if line.start_with?("```")
    next if in_code || line.start_with?("```")
    next if line.start_with?("###")
    next if line.empty?
    next if line =~ /^`[^`]+`$/

    unless line.start_with?("- ")
      violations << [id, "missing emphasis", (line[0..60] || ""), "expected `- ` prefix"]
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 emphasis violations"
else
  puts "maxim emphasis violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
