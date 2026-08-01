#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — summary report of all identities after extraction
# survey: identities-extraction

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/patlib"
require_relative "../../_rb/rings"
require_relative "../../_rb/report"

# 1. Count identities
identity_files = Dir[EntityGlob.call("identities")].sort
identity_ids = identity_files.map { |p| File.basename(p, ".md") }

puts "=== IDENTITIES Summary ==="
puts
puts "Directory: entities/identities/"
puts "Total files: #{identity_files.size}"
puts "Ring: R3 Encyclopedic (Term, Identity, Biology, Chemical)"
puts

# 2. Table of all identities
rows = identity_files.map { |p|
  base = File.basename(p, ".md")
  text = File.read(p)
  meta = ParseMetadata.call(text)
  title = meta ? meta[:title].to_s : "(unparseable)"
  src = meta ? meta[:source].to_s : "-"
  tg = meta ? (meta[:tags].is_a?(Array) ? meta[:tags].join(",") : meta[:tags].to_s) : "-"
  [base, title[0..45], src, tg]
}
puts Table.call(rows, %w[ID Title Source Tags])
puts

# 3. Cross-ref check — what references IDENTITY.* entities?
puts "=== Cross-References to IDENTITY.* ==="
refs = []
identity_ids.each do |id|
  EntityTypes.each do |type|
    Dir[EntityGlob.call(type)].each do |path|
      base = File.basename(path, ".md")
      next if identity_ids.include?(base)
      text = File.read(path)
      meta = ParseMetadata.call(text)
      next unless meta
      src = meta[:source].to_s
      if src == id
        refs << [base, type, "source", id]
      end
      rel = meta[:related]
      if rel.is_a?(Array)
        rel.each { |r| refs << [base, type, "related", r.to_s] if r.to_s == id }
      end
    end
  end
end

if refs.empty?
  puts "No cross-references yet (IDENTITY.* is new)."
else
  puts Table.call(refs, %w[Entity Type Field Target])
  puts
  puts "#{refs.size} references"
end
