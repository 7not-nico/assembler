#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey stale references in commands/ .md and .yaml files
# survey: commands-stale-survey

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"

### Build active entity index

active_ids = {}
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    text = File.read(path)
    m = text.match(/^(?:---.*?---\n)?(?:.*?\n)?id:\s+(\S+)/m)
    active_ids[m[1]] = type if m
  end
end

# Also index skill IDs (SKL.* from SKILL.md dirname)
Dir[SKILLS.join("*", "SKILL.md")].each do |path|
  dir = File.basename(File.dirname(path))
  active_ids["SKL.#{dir.upcase.tr('-', '.')}"] = "skill"
end

# Index rule YAML IDs
Dir[RULES.join("yamls", "*.yaml")].each do |path|
  text = File.read(path)
  if text =~ /^id:\s+(\S+)/
    active_ids[$1] = "rule-yaml"
  end
end

# Index command YAML IDs
Dir[COMMANDS.join("yamls", "*.yaml")].each do |path|
  text = File.read(path)
  if text =~ /^id:\s+(\S+)/
    active_ids[$1] = "command-yaml"
  end
end

### Stale path patterns

STALE_PATH_PATTERNS = [
  [".opencode/backups/", ".opencode/_backups/"],
  [".opencode/terms/TERM.", ".opencode/entities/terms/TERM."],
  [".opencode/manifests/", ".opencode/entities/manifests/"],
]

### Scan command .md files

md_violations = []
bad_yaml_refs = []

Dir[COMMANDS.join("*.md")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  rel = Pathname.new(path).relative_path_from(ROOT).to_s

  STALE_PATH_PATTERNS.each do |old, new|
    if text.include?(old)
      text.lines.each_with_index do |line, i|
        if line.include?(old)
          md_violations << [rel, "stale-path", old, new, (i+1).to_s, line.strip]
        end
      end
    end
  end
end

### Scan command YAML related fields

Dir[COMMANDS.join("yamls", "*.yaml")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".yaml")
  rel = Pathname.new(path).relative_path_from(ROOT).to_s

  begin
    data = YAML.unsafe_load(text)
    if data
      related = Array(data["related"] || data[:related])
      related.each do |r|
        next unless r.is_a?(String)
        rid = r.strip
        unless active_ids.key?(rid)
          bad_yaml_refs << [rel, "unresolved-ref", rid, "related field"]
        end
      end
    end
  rescue => e
    bad_yaml_refs << [rel, "parse-error", e.message, "yaml parse"]
  end
end

### Output

puts "=== Commands Stale Survey ==="
puts
puts "Active entities indexed: #{active_ids.size}"

puts
puts "--- Stale path references ---"
puts
if md_violations.empty?
  puts "  (none)"
else
  rows = md_violations.map { |v| [v[0], v[2], v[3], v[5]] }
  puts Table.call(rows, %w[File Old-Path Should-Be Line])
end

puts
puts "--- Unresolved YAML related refs ---"
puts
if bad_yaml_refs.empty?
  puts "  (none)"
else
  rows = bad_yaml_refs.map { |v| [v[0], v[2]] }
  puts Table.call(rows, %w[File Unresolved-ID])
end

puts
puts "--- Command YAML related field index (all) ---"
puts
Dir[COMMANDS.join("yamls", "*.yaml")].sort.each do |path|
  base = File.basename(path, ".yaml")
  text = File.read(path)
  begin
    data = YAML.unsafe_load(text)
    if data
      related = Array(data["related"] || data[:related])
      unless related.empty?
        puts "  #{base}: #{related.join(", ")}"
      end
    end
  rescue => e
    puts "  #{base}: (parse error: #{e.message})"
  end
end

puts
puts "--- Command descriptions (all) ---"
puts
Dir[COMMANDS.join("*.md")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  m = text.match(/^description:\s*(.+)$/)
  desc = m ? m[1].strip : "(no description)"
  puts "  #{base}: #{desc}"
end
