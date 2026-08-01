#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — show MAX frontmatter → SPEC backmatter conversion
# survey: specification-migration

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

CANDIDATES = {
  "MAX.KNOWLEDGE.CLASSIFICATION" => "SPEC.KNOWLEDGE.CLASSIFICATION",
  "MAX.ENTITY.ONTOLOGY"          => "SPEC.ENTITY.ONTOLOGY",
  "MAX.ENTITY.DISCERNIBILITY"    => "SPEC.ENTITY.DISCERNIBILITY",
  "MAX.ENTITY.RECLASSIFY"        => "SPEC.ENTITY.RECLASSIFY"
}

REMOVED_FIELDS = %w[principle enforcement].freeze

Dir[EntityGlob.call("maxims")].sort.each do |path|
  base = File.basename(path, ".md")
  target = CANDIDATES[base]
  next unless target

  text = File.read(path)
  fm = ParseFrontmatter.call(text)

  puts "=== PREVIEW: #{base} → #{target} ==="
  puts

  puts "--- Current (maxim frontmatter) ---"
  if fm
    fm.each { |k, v| puts "  #{k}: #{v.inspect}" }
  else
    puts "  (no parseable frontmatter)"
  end
  puts

  body = text.dup
  body.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
  body.sub!(/---\s*\n.*?\n---\s*\z/m, "")

  body_lines = body.strip.lines[0..5].map(&:strip).reject(&:empty?)
  puts "--- Body (first #{[body_lines.size, 5].min} lines) ---"
  body_lines.first(5).each { |l| puts "  #{l}" }
  puts

  puts "--- Proposed SPEC backmatter ---"
  puts
  puts "  [Body content unchanged, cat section dropped]"
  puts "  ---"
  if fm
    fm.each do |k, v|
      next if REMOVED_FIELDS.include?(k.to_s)
      if k.to_s == "tags"
        tags = v.is_a?(Array) ? v.dup : v.to_s.split(",").map(&:strip)
        tags << "specification" unless tags.include?("specification")
        puts "  #{k}: #{tags.inspect}"
      else
        puts "  #{k}: #{v.inspect}"
      end
    end
  end
  puts "  ---"
  puts

  puts "Changes:"
  puts "  + ID: #{base} → #{target}"
  puts "  + Position: frontmatter → backmatter"
  puts "  − Fields dropped: #{REMOVED_FIELDS.join(", ")}"
  puts "  + Tags: +specification"
  puts "  − Cat section: dropped (specifications don't use junction format)"
  puts
end
