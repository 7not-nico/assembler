#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — cross-reference validation
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/entity

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/entity"

entries = LoadAllEntities.call

known_ids = entries.map { |e| e[:id] }.to_set

file_paths = EntityTypes.flat_map { |t|
  Dir[EntityGlob.call(t)].map { |p| [File.basename(p, ".md"), p] }
}.to_h

PATLIB_ID = /\b[A-Z]{2,}(?:\.[A-Z][A-Z0-9.\/-]*)+/
FindRefs = ->(text) { text.scan(PATLIB_ID).flatten.uniq }

rows = entries.filter_map { |e|
  path = file_paths[e[:file]]
  next unless path
  text = File.read(path)
  refs = FindRefs.call(text) - [e[:id].to_s]
  bad = refs.reject { |id| known_ids.include?(id.to_sym) }
  bad.empty? ? nil : [e[:id], e[:type], bad.join(", ")]
}

if rows.empty?
  puts "ok — #{entries.size} entities, 0 unresolvable refs"
else
  puts "unresolvable refs:"
  puts Table.call(rows, %w[ID Type Unresolved])
end
