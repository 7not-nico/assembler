#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — analyze all PROT.*.IDENTITY files for migration to IDENTITY.*
# migration: identities — maps current protocol identities to target IDENTITY entities

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/patlib"
require_relative "../../_rb/report"

candidates = []

Dir[EntityGlob.call("protocols")].each do |path|
  base = File.basename(path, ".md")
  next unless base.match?(/\.IDENTITY$/)

  text = File.read(path)
  meta = ParseMetadata.call(text)
  next unless meta

  target_id = "IDENTITY." + base.sub(/^PROT\./, "").sub(/\.IDENTITY$/, "")

  candidates << [
    base,
    meta[:title].to_s[0..40],
    meta[:source].to_s,
    meta[:status].to_s,
    target_id
  ]
end

puts "=== Protocol Identity → IDENTITY.* Migration Candidates ==="
puts
if candidates.empty?
  puts "No PROT.*.IDENTITY candidates found."
else
  puts Table.call(candidates, %w[Current Title Source Status Target])
  puts
  puts "#{candidates.size} candidates for migration"
  puts "Target directory: entities/identities/"
  puts "Target format: backmatter (body + --- YAML)"
end
