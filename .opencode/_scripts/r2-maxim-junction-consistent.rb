#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — consistent trailing period usage in cat lines
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
  next if cat_lines.empty?

  # Determine if this file uses trailing periods (majority rule)
  punct_count = cat_lines.count { |l| l.end_with?(".") }
  no_punct_count = cat_lines.count { |l| !l.end_with?(".") && l.start_with?("- ") }

  # Only flag if mixed — majority wins
  if punct_count > 0 && no_punct_count > 0
    if punct_count > no_punct_count
      # Most have periods — flag those without
      cat_lines.each_with_index do |line, idx|
        if line.start_with?("- ") && !line.end_with?(".")
          violations << [id, "missing trailing .", line[0..50], "add `.` for consistency"]
        end
      end
    else
      # Most lack periods — flag those with
      cat_lines.each_with_index do |line, idx|
        if line.start_with?("- ") && line.end_with?(".")
          violations << [id, "extra trailing .", line[0..50], "remove `.` for consistency"]
        end
      end
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 trailing period violations"
else
  puts "maxim trailing period violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
