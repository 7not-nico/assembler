#!/usr/bin/env ruby
# ring: 1 (DB-READ) — entity classification
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/entity

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/entity"

entries = LoadAllEntities.call

rows = entries.map { |e| [e[:id], e[:type], (e[:tags] || []).join(", ")] }
puts Table.call(rows, %w[ID Type Tags])
