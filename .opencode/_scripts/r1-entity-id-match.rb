#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — entity backmatter id matches filename

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

violations = []

EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)

    unless meta
      violations << [base, type, "id", "no metadata found"]
      next
    end

    rid = meta[:id]
    if rid.nil? || rid.to_s.empty?
      violations << [base, type, "id", "missing id field"]
    elsif rid.to_s != base
      violations << [base, type, "id", "backmatter id=#{rid} != filename #{base}"]
    end
  end
end

if violations.empty?
  puts "ok — #{EntityTypes.size} entity types, 0 id mismatches"
else
  puts "id mismatches (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Field Detail])
end
