#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify all cross-references to PROT.*.IDENTITY entities
# migration: identities — documents impact of migrating identity protocols

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

identity_protocols = Dir[EntityGlob.call("protocols")].map { |p|
  File.basename(p, ".md")
}.select { |b| b.match?(/\.IDENTITY$/) }

refs = []
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    src = meta[:source].to_s
    if identity_protocols.include?(src)
      refs << [base, type, "source", src]
    end

    related = meta[:related]
    if related.is_a?(Array)
      related.each do |r|
        rid = r.to_s.strip
        if identity_protocols.include?(rid)
          refs << [base, type, "related", rid]
        end
      end
    end

    see_also = meta[:see_also]
    if see_also.is_a?(Array)
      see_also.each do |r|
        rid = r.to_s.strip
        if identity_protocols.include?(rid)
          refs << [base, type, "see_also", rid]
        end
      end
    end
  end
end

puts "=== Cross-Reference Impact: PROT.*.IDENTITY ==="
puts
if refs.empty?
  puts "No cross-references found — zero impact migration."
else
  impacted = refs.map { |r| r[3] }.uniq
  puts Table.call(refs, %w[Entity Type Field Reference])
  puts
  puts "#{refs.size} references across #{impacted.size} identity protocols"
  impacted.each do |id|
    count = refs.count { |r| r[3] == id }
    puts "  #{id}: #{count} references"
  end
end
