#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify tag format: comma-separated, no spaces within tags, no YAML arrays

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
    next unless meta

    tg = meta[:tags]
    next if tg.nil? || (tg.respond_to?(:empty?) && tg.empty?)

    tags = tg.is_a?(Array) ? tg : tg.to_s.split(",").map(&:strip)

    if tg.is_a?(Array)
      violations << [base, type, "tags", "YAML array; use comma-separated string"]
    end

    tags.each do |t|
      next if t.nil? || t.empty?
      if t.include?(" ")
        violations << [base, type, "tag", "tag '#{t}' contains space — use hyphens or dots"]
      end
      if t.match?(/[A-Z]/)
        violations << [base, type, "tag", "tag '#{t}' has uppercase — use lowercase"]
      end
    end
  end
end

if violations.empty?
  puts "ok — #{EntityTypes.size} entity types, all tags well-formed"
else
  puts "tag format violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Field Problem])
end
