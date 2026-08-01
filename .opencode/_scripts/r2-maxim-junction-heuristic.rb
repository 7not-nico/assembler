#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — heuristic ; misuse: right clause lacks negation
# depends-on: _rb/paths, _rb/frontmatter, _rb/body, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/body"
require_relative "_rb/report"

TARGET_TYPE = "maxims"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []

NEGATION = /\b(not|never|no\b|except|unless|without|instead|nor|none|nothing|nobody|insufficient)\b/i

files.each do |path|
  text = File.read(path)
  basename = File.basename(path, ".md")
  fm = ParseFrontmatter.call(text)
  next unless fm
  id = fm[:id] || basename

  cat_lines = ExtractCatSection.call(text)
  cat_lines.each do |line|
    next unless line.include?(";")

    # Split on ; but skip the first (left side)
    parts = line.split(";", -1)
    next if parts.size < 2

    # Check each right-side clause
    parts[1..].each_with_index do |right, idx|
      right = right.strip.sub(/\.$/, "")
      next if right.empty?
      unless right.match?(NEGATION)
        violations << [id, "likely `,` not `;`", line[0..60], "right clause lacks negation: \"#{right[0..40]}\""]
      end
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 heuristic violations"
else
  puts "maxim heuristic violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Issue Line Suggestion])
end
