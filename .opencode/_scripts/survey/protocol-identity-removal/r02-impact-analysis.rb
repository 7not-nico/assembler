#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — find all cross-references to PROT.*.IDENTITY that would break on removal
# survey: protocol-identity-removal

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
    next if base.match?(/\.IDENTITY$/)  # skip protocols themselves
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
  end
end

puts "=== Cross-References to PROT.*.IDENTITY ==="
puts
if refs.empty?
  puts "No cross-references — zero impact removal."
else
  impacted = refs.map { |r| r[3] }.uniq.sort
  counts = impacted.map { |id| [id, refs.count { |r| r[3] == id }] }

  puts Table.call(refs, %w[Entity Type Field Reference])
  puts
  puts "Summary by protocol:"
  counts.each { |id, cnt| puts "  #{id}: #{cnt} references" }
  puts
  puts "Total: #{refs.size} references across #{impacted.size} protocols"
  puts
  puts "Action: after PROT.*.IDENTITY removal, update these references to point to IDENTITY.*"
end
