#!/usr/bin/env ruby
# ring: 0 (PURE) — entity count per type
# depends-on: _rb/paths, _rb/frontmatter, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

counts = EntityTypes.map { |t|
  files = Dir[EntityGlob.call(t)]
  texts = files.map { |p| File.read(p) }
  entries = ParseAll.call(texts, files.map { |p| File.basename(p, ".md") })
  [t, entries.size]
}

puts Table.call(counts, %w[Type Count])
