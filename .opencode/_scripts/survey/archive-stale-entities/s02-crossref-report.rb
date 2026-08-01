#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — find all cross-references to stale entities
# survey: archive-stale-entities

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

STALE_IDS = [
  "PROT.META.ENTITY.DISTINCTION",
  "RUL.PATTERN.VS.TERM",
  "pattern-vs-term"
].freeze

REPLACEMENT = "SPEC.META.ENTITY.DISTINCTION"

refs = []

# 1. Entity directories (all active entity dirs under .opencode/entities/)
EntityTypes.each do |type|
  next if type == "archives"
  Dir[EntityGlob.call(type)].each do |path|
    text = File.read(path)
    rel = Pathname.new(path).relative_path_from(ROOT).to_s
    base = File.basename(path, ".md")
    meta = ParseMetadata.call(text)

    if meta
      meta.each do |k, v|
        next if k.to_s == "id"
        next unless v.is_a?(String) || v.is_a?(Array)
        vals = Array(v).map(&:to_s)
        STALE_IDS.each do |sid|
          if vals.include?(sid)
            origin = k.to_s == "related" ? "related" :
                     k.to_s == "illustrates" ? "illustrates" :
                     k.to_s == "source" ? "source" : k.to_s
            refs << [rel, base, type, sid, origin, "metadata"]
          end
        end
      end
    end

    body = text.dup
    body.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
    body.sub!(/---\s*\n.*?\n---\s*\z/m, "")

    STALE_IDS.each do |sid|
      body.scan(/\b#{Regexp.escape(sid)}\b/) do
        refs << [rel, base, type, sid, "body", "mention"]
      end
    end
  end
end

# 2. Rules directory (markdown files, not entity-managed)
Dir[RULES.join("*.md")].each do |path|
  next if path.include?("pattern-vs-term.md")
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  base = File.basename(path, ".md")
  STALE_IDS.each do |sid|
    text.scan(/\b#{Regexp.escape(sid)}\b/) do
      refs << [rel, base, "rules", sid, "body", "mention"]
    end
  end
end

# 3. Rules YAML registries
Dir[RULES.join("yamls", "*.yaml")].each do |path|
  next if path.include?("pattern-vs-term.yaml")
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  base = File.basename(path, ".yaml")
  STALE_IDS.each do |sid|
    text.scan(/\b#{Regexp.escape(sid)}\b/) do
      refs << [rel, base, "rules-yaml", sid, "body", "mention"]
    end
  end
end

# 4. Commands directory
Dir[COMMANDS.join("*.md")].each do |path|
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  base = File.basename(path, ".md")
  STALE_IDS.each do |sid|
    text.scan(/\b#{Regexp.escape(sid)}\b/) do
      refs << [rel, base, "commands", sid, "body", "mention"]
    end
  end
end

# 5. Skills (SKILL.md files)
Dir[SKILLS.join("*", "SKILL.md")].each do |path|
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  base = File.basename(File.dirname(path))
  STALE_IDS.each do |sid|
    text.scan(/\b#{Regexp.escape(sid)}\b/) do
      refs << [rel, base, "skill", sid, "body", "mention"]
    end
  end
end

puts "=== Archive Stale Entities — Cross-Reference Report ==="
puts
puts "Total: #{refs.size} references across #{refs.map { |r| r[0] }.uniq.size} unique files"
puts "Target replacement: #{REPLACEMENT}"
puts

STALE_IDS.each do |sid|
  sid_refs = refs.select { |r| r[3] == sid }
  next if sid_refs.empty?

  puts "#{sid} (#{sid_refs.size} refs)"
  puts

  by_origin = sid_refs.group_by { |r| r[4] }.sort
  by_origin.each do |origin, group|
    puts "  #{origin} (#{group.size}):"
    group.each do |r|
      context = r[5] == "metadata" ? "(frontmatter)" : "(body)"
      puts "    #{r[0]} — #{context}"
    end
    puts
  end
end

puts "=== Summary ==="
puts
STALE_IDS.each do |sid|
  count = refs.count { |r| r[3] == sid }
  puts "  #{sid}: #{count} refs"
end
puts
puts "Files to update: #{refs.map { |r| r[0] }.uniq.size}"

# Group by file for final table
puts
puts "=== Files requiring changes ==="
puts
files = refs.group_by { |r| r[0] }.sort
file_rows = files.map do |fpath, frefs|
  stale = frefs.map { |r| r[3] }.uniq.join(", ")
  origins = frefs.map { |r| r[4] }.uniq.join(", ")
  [fpath, frefs.size.to_s, stale, origins]
end
puts Table.call(file_rows, %w[File Refs Stale-ID Origin])
