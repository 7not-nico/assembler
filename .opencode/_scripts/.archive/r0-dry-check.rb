#!/usr/bin/env ruby
# ring: 0 (PURE) — foundational data integrity
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/entity

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/entity"

entries = LoadAllEntities.call

by_id = entries.group_by { |e| e[:id] }
dupes = by_id.select { |_, g| g.size > 1 }

if dupes.empty?
  puts "ok — #{entries.size} entities, 0 duplicate IDs"
else
  puts "duplicate IDs (#{entries.size} entities):"
  puts Table.call(
    dupes.flat_map { |id, g| g.map { |e| [id, e[:type], e[:file]] } },
    %w[ID Type File]
  )
end
