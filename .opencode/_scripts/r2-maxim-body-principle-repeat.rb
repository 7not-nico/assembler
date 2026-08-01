#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — bold line restates principle (per PROT.MAXIM.IDENTITY:1)
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

  # Extract body: everything after last `---` delimiter
  if text =~ /^---\n.*?\n---\n/m
    body = $~.post_match
  else
    body = text
  end
  bold_line = body.lines.map(&:strip).reject(&:empty?).first.to_s

  unless bold_line =~ /\A\*\*[^*]+\*\*\s*[—–-]/
    violations << [id, "missing bold principle", "", "first body line must be **Title** — description"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 principle repeat violations"
else
  puts "maxim principle repeat violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
