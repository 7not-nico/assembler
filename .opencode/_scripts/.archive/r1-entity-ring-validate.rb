#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify entity type matches its file prefix per MAX.KNOWLEDGE.CLASSIFICATION

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/patlib"
require_relative "_rb/rings"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

violations = []
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    prefix = base.split(".").first

    expected_type = PrefixToType[prefix]
    unless expected_type
      violations << [base, type, prefix, "unrecognized prefix"]
      next
    end

    unless expected_type == type
      violations << [base, type, prefix, "prefix #{prefix}→#{expected_type}, file in #{type}"]
    end

    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    rid = (meta[:id] || base).to_s
    id_prefix = rid.split(".").first
    id_type = PrefixToType[id_prefix]
    unless id_type
      violations << [base, type, "id:#{rid}", "id prefix #{id_prefix} unrecognized"]
      next
    end

    unless id_type == type
      violations << [base, type, "id:#{rid}", "id prefix #{id_prefix}→#{id_type}, file in #{type}"]
    end
  end
end

if violations.empty?
  puts "ok — #{EntityTypes.size} entity types, all prefix↔type mappings valid"
else
  puts "ring violations (#{violations.size}):"
  puts Table.call(violations, %w[File Type Prefix Problem])
end
