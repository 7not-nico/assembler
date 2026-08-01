#!/usr/bin/env ruby
# s01-map-ids.rb — survey: map all Composition entity IDs to 3-segment PREFIX.DOMAIN.ASPECT
# ring: 1 (LOCAL-READ)
# non-write

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

DIRS = {
  protocols:      ".opencode/entities/protocols",
  patterns:       ".opencode/entities/patterns",
  nexus:          ".opencode/entities/nexus",
  illustrations:  ".opencode/entities/illustrations",
  references:     ".opencode/entities/references",
}

puts "=== Composition Group Segment Migration Map ==="
puts "PREFIX.DOMAIN.SUBJECT.ASPECT → PREFIX.DOMAIN.ASPECT"
puts ""
puts "%-58s %-45s %s" % ["OLD ID", "NEW ID", "CHANGE"]
puts "-" * 130

total = 0
DIRS.each do |type, dir|
  path = ROOT.join(dir)
  Dir[path.join("*.md")].sort.each do |f|
    text = File.read(f)
    parts = text.split(/^---$/).reject(&:empty?)
    next if parts.empty?
    begin
      yml = YAML.safe_load(parts[0].strip)
      next unless yml.is_a?(Hash)
      old_id = yml["id"]
      next unless old_id
      segs = old_id.split(".").size
      prefix = old_id.split(".").first

      if segs <= 3
        # Already compliant
        change = "NONE"
        new_id = old_id
      else
        # 4+ segments → PREFIX.DOMAIN.ASPECT
        parts_a = old_id.split(".")
        new_id = "#{parts_a[0]}.#{parts_a[1]}.#{parts_a[-1]}"
        change = "DROP"
      end

      total += 1
      change_str = change == "DROP" ? "DROP" : "  OK"
      puts "%-58s %-45s %s" % [old_id, new_id, change_str]
    rescue => e
      $stderr.puts "PARSE_ERROR: #{f}: #{e.message}"
    end
  end
end

puts ""
puts "Total Composition entities: #{total}"
