#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — no blank lines inside categorization section
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

  in_maxim = false
  cat_started = false
  cat_ended = false
  prev_blank = false

  text.each_line do |line|
    if line =~ /^\*\*[^*]+\*\*[—–-]/
      in_maxim = true
      next
    end
    next unless in_maxim

    if line =~ /^## /
      if cat_started
        cat_ended = true
        break
      end
      cat_started = true
      prev_blank = false
      next
    end

    next unless cat_started && !cat_ended
    stripped = line.strip

    if stripped.empty?
      prev_blank = true
    else
      if prev_blank && stripped.start_with?("- ")
        violations << [id, "blank gap", "blank line before junction", "remove blank between junctions"]
      end
      prev_blank = false
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 blank gap violations"
else
  puts "maxim blank gap violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
