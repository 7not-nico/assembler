#!/usr/bin/env ruby
# ring: 1 (DB-READ) — ID pattern analysis
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/entity

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/entity"

entries = LoadAllEntities.call

SegmentDepth = ->(id) { id.to_s.scan(/\./).size + 1 }

rows = entries.map { |e| [e[:id], e[:type], SegmentDepth.call(e[:id]).to_s] }
puts Table.call(rows, %w[ID Type Segments])
