#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify every entity file has parseable metadata

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

missing = []
empty_fields = []

EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)

    unless meta
      missing << [base, type, "no parseable frontmatter/backmatter"]
      next
    end

    %i[id title].each do |f|
      if meta[f].nil? || meta[f].to_s.strip.empty?
        empty_fields << [base, type, f.to_s, "empty"]
      end
    end

    if meta[:source].nil? || meta[:source].to_s.strip.empty?
      empty_fields << [base, type, "source", "empty"]
    end
  end
end

if missing.empty? && empty_fields.empty?
  puts "ok — #{EntityTypes.size} entity types, all metadata parseable"
else
  unless missing.empty?
    puts "unparseable metadata (#{missing.size}):"
    puts Table.call(missing, %w[ID Type Problem])
    puts
  end
  unless empty_fields.empty?
    puts "empty required fields (#{empty_fields.size}):"
    puts Table.call(empty_fields, %w[ID Type Field Problem])
  end
end
