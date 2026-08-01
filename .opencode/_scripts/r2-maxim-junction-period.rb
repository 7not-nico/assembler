#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — no period separating two clauses in categorization lines
# depends-on: _rb/paths, _rb/frontmatter, _rb/body, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/body"
require_relative "_rb/report"

TARGET_TYPE = "maxims"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []

ABBREVIATIONS = %w[e.g i.e etc]

files.each do |path|
  text = File.read(path)
  basename = File.basename(path, ".md")
  fm = ParseFrontmatter.call(text)
  next unless fm
  id = fm[:id] || basename

  cat_lines = ExtractCatSection.call(text)
  cat_lines.each_with_index do |line, idx|
    content = line
    # Remove the `- ` prefix for content checking
    content = content[2..] if content.start_with?("- ")

    next if content.nil? || content.empty?

    # Find `. ` followed by uppercase, digit, quote, backtick, or paren
    content.scan(/\.[ ]+([A-Z0-9("`])/) do
      pre = $` || ""
      # Skip known abbreviations
      abbr = pre.split(/\s/).last
      next if abbr && ABBREVIATIONS.include?(abbr)

      violations << [id, "period clause", line[0..70], "use `,` (qualify) or `;` (except)"]
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 period-clause violations"
else
  puts "maxim period-clause violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
