#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — status field is active or draft
# depends-on: _rb/paths, _rb/frontmatter, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

TARGET_TYPE = "maxims"
files = Dir[EntityGlob.call(TARGET_TYPE)]
violations = []
VALID = %w[active draft]

files.each do |path|
  text = File.read(path)
  basename = File.basename(path, ".md")
  fm = ParseFrontmatter.call(text)
  next unless fm
  id = fm[:id] || basename

  val = fm[:status].to_s.strip
  unless VALID.include?(val)
    violations << [id, "invalid status", val, "must be active or draft"]
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 status violations"
else
  puts "maxim status violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Value Fix])
end
