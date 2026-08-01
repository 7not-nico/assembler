#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — find all references to MAX.METADATA.STRATUM that need updating
# survey: metadata-stratum — plan reference updates after maxim→protocol conversion

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

refs = []

EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    if meta[:source].to_s == "MAX.METADATA.STRATUM"
      refs << [base, type, "source", "source should change to PROT.METADATA.STRATUM"]
    end

    related = meta[:related]
    if related.is_a?(Array) && related.map(&:to_s).include?("MAX.METADATA.STRATUM")
      refs << [base, type, "related", "related should change to PROT.METADATA.STRATUM"]
    end
  end
end

puts "=== MAX.METADATA.STRATUM Reference Impact ==="
puts
if refs.empty?
  puts "No references found — zero impact deletion."
else
  puts Table.call(refs, %w[Entity Type Field Action])
  puts
  puts "#{refs.size} references to update after deletion"
  refs.group_by { |r| r[3] }.each do |action, group|
    puts "  #{action}: #{group.size} entities"
  end
end
