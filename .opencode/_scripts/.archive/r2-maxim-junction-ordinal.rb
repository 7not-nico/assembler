#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — ring numbers in cat section ascend monotonically
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

  in_maxim = false
  cat_started = false
  cat_ended = false
  last_ring = -1

  text.each_line do |line|
    if line =~ /^\*\*[^*]+\*\*\s*[—–-]/
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
      next
    end

    next unless cat_started && !cat_ended

    # Extract ring number from "Ring N:" pattern
    if line =~ /Ring (\d+):/
      ring_num = $1.to_i
      # Allow restart at 0 for new groups
      if ring_num == 0
        last_ring = 0
        next
      end
      if ring_num < last_ring
        violations << [id, "ring out of order", "Ring #{ring_num} after Ring #{last_ring}", "ring numbers must ascend"]
      end
      last_ring = ring_num if ring_num > last_ring
    end
  end
end

if violations.empty?
  puts "ok — #{files.size} #{TARGET_TYPE}, 0 ordinal violations"
else
  puts "maxim ordinal violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Problem Line Fix])
end
