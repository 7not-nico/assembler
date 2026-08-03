#!/usr/bin/env ruby
# ring: 0 (PURE) — raw frontmatter dump
# depends-on: _rb/paths, _rb/frontmatter

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"

TYPES = EntityTypes + ExternalTypes.call
files = TYPES.flat_map { |t|
  Dir[EntityGlob.call(t)].map { |p| { type: t, path: Pathname.new(p), name: File.basename(p, ".md") } }
}
texts = files.map { |f| f[:path].read }
entries = ParseAll.call(texts, files.map { |f| f[:name] })
entries.each { |e| e[:type] = files.find { |f| f[:name] == e[:file] }[:type] }

entries.each do |e|
  puts "--- #{e[:type]} / #{e[:file]} ---"
  puts YAML.dump(e.to_a.map { |k, v| [k.to_s, v] }.to_h)
end
