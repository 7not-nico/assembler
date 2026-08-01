#!/usr/bin/env ruby
# ring: 0 (PURE) — entity ring distribution
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/rings, _rb/entity

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/rings"
require_relative "_rb/entity"

entries = LoadAllEntities.call

ring_map = {}
unclassified = []

entries.each do |e|
  info = TypeToRing.call(e[:type])
  if info
    key = [info[:group], info[:ring]]
    ring_map[key] = (ring_map[key] || 0) + 1
  else
    unclassified << e
  end
end

groups = %i[axiomatic encyclopedic composition architectonic chronicle]
max_rings = groups.map { |g| (RingGroups[g]&.keys || []).max }.max

rows = groups.map do |g|
  rings = RingGroups[g] || {}
  row = [g.to_s.capitalize]
  (0..max_rings).each do |r|
    if rings[r]
      row << (ring_map[[g, r]] || 0).to_s
    else
      row << ""
    end
  end
  row
end

headers = ["Group"] + (0..max_rings).map { |r| "R#{r}" }

puts "Ring distribution per MAX.KNOWLEDGE.CLASSIFICATION"
puts "=" * 60
puts Table.call(rows, headers)
puts
puts "Total entities: #{entries.size}"
puts "Unclassified types (#{unclassified.size}): #{unclassified.map { |e| "#{e[:type]}:#{e[:id]}" }.join(", ")}" unless unclassified.empty?
