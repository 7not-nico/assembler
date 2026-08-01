#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — find all cross-references to 4 candidate MAX.*
# survey: specification-migration

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/patlib"
require_relative "../../_rb/report"

CANDIDATE_TARGET = {
  "MAX.KNOWLEDGE.CLASSIFICATION" => "SPEC.KNOWLEDGE.CLASSIFICATION",
  "MAX.ENTITY.ONTOLOGY"          => "SPEC.ENTITY.ONTOLOGY",
  "MAX.ENTITY.DISCERNIBILITY"    => "SPEC.ENTITY.DISCERNIBILITY",
  "MAX.ENTITY.RECLASSIFY"        => "SPEC.ENTITY.RECLASSIFY"
}

CANDIDATES = CANDIDATE_TARGET.keys.freeze

refs = []

EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)

    if meta
      meta.each do |k, v|
        next if k.to_s == "id"
        next unless v.is_a?(String) || v.is_a?(Array)
        vals = Array(v).map(&:to_s)
        CANDIDATES.each do |cid|
          if vals.include?(cid)
            refs << [base, type, cid, k.to_s, "metadata"]
          end
        end
      end
    end

    body = text.dup
    body.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
    body.sub!(/---\s*\n.*?\n---\s*\z/m, "")

    CANDIDATES.each do |cid|
      count = body.scan(/\b#{Regexp.escape(cid)}\b/).size
      if count > 0
        refs << [base, type, cid, "body", "#{count} mention(s)"]
      end
    end
  end
end

[RULES, COMMANDS].each do |dir|
  next unless Dir.exist?(dir)
  Dir[File.join(dir, "**", "*.md")].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    meta.each do |k, v|
      next unless v.is_a?(String) || v.is_a?(Array)
      vals = Array(v).map(&:to_s)
      CANDIDATES.each do |cid|
        if vals.include?(cid)
          refs << [base, "rules-yaml", cid, k.to_s, "metadata"]
        end
      end
    end
  end
end

puts "=== Specification Migration — Impact Report ==="
puts
puts "Total: #{refs.size} references across #{refs.map { |r| r[0] }.uniq.size} unique files"
puts

CANDIDATES.each do |cid|
  candidate_refs = refs.select { |r| r[2] == cid }
  target = CANDIDATE_TARGET[cid]
  puts "#{cid} → #{target} (#{candidate_refs.size} refs)"
  puts

  if candidate_refs.empty?
    puts "  (none — clean migration)"
    puts
    next
  end

  by_field = candidate_refs.group_by { |r| r[3] }.sort
  by_field.each do |field, group|
    puts "  #{field} (#{group.size}):"
    group.each do |r|
      context = r[4] == "body" ? r[4] : r[4]
      puts "    #{r[0]} (#{r[1]}) — #{r[4]}"
    end
    puts
  end
end

puts "=== Summary ==="
puts
CANDIDATES.each do |cid|
  c = refs.count { |r| r[2] == cid }
  target = CANDIDATE_TARGET[cid]
  puts "  #{cid} → #{target}: #{c} refs"
end
puts
puts "Files to update: #{refs.map { |r| r[0] }.uniq.size}"
