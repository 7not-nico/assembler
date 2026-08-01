#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — classify each command by staleness indicators
# survey: commands-stale-survey
# granular checks per command: cross-ref count, skill overlap, path staleness, orphan status

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"
require_relative "../../_rb/entity"

ARCHIVE_DIR = ROOT.join("_scripts", "archive")

### Build indexes

active_entity_ids = {}
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    text = File.read(path)
    m = text.match(/^(?:---.*?---\n)?(?:.*?\n)?id:\s+(\S+)/m)
    active_entity_ids[m[1]] = type if m
  end
end

skill_names = Dir[SKILLS.join("*", "SKILL.md")].map { |p| File.basename(File.dirname(p)) }

### Scan each command

results = []

Dir[COMMANDS.join("*.md")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  yaml_path = COMMANDS.join("yamls", "#{base}.yaml")
  yaml_exists = yaml_path.exist?

  # Cross-reference count (excluding self)
  xrefs = 0
  xref_sources = []
  Dir[ROOT.join(".opencode", "**", "*.{md,yaml}")].each do |p|
    next if p.include?("/_scripts/") || p.include?("/archive/") || p.include?("/backups/")
    content = File.read(p)
    pref = "CMD.#{base.upcase.tr('-', '.')}"
    if content.include?(pref) || content.include?("commands/#{base}") || content.include?("command/#{base}")
      rrel = Pathname.new(p).relative_path_from(ROOT).to_s
      next if rrel == rel || rrel == yaml_path.to_s
      xrefs += 1
      xref_sources << rrel
    end
  end

  # Skill overlap: check if a skill with same name exists
  matching_skill = nil
  matching_skill = base if skill_names.include?(base)

  # Stale path indicators in the command body
  stale_paths = []
  stale_paths << ".opencode/backups/" if text.include?(".opencode/backups/")
  stale_paths << ".opencode/terms/" if text.include?(".opencode/terms/") && !text.include?("entities/terms")
  stale_paths << "rules/yamls/pattern-vs-term" if text.include?("pattern-vs-term")

  # Description
  desc = text.match(/^description:\s*(.+)$/)
  desc = desc ? desc[1].strip : "(none)"

  # Z-prefix indicator
  z_prefix = base.start_with?("z")

  results << [base, desc, xrefs.to_s, xref_sources.empty? ? "-" : xref_sources.join(", "), matching_skill || "-", stale_paths.empty? ? "clean" : stale_paths.join(", "), z_prefix ? "z" : "-"]
end

### Output

puts "=== Command Staleness Classification ==="
puts

headers = %w[Command Description XRefs XRef-Sources Matching-Skill Stale-Paths Z]
rows = results.map { |r| [r[0], r[1], r[2], r[3], r[4], r[5], r[6]] }
puts Table.call(rows, headers)

puts
puts "--- Summary by staleness ---"
puts

orphans = results.select { |r| r[2] == "0" && r[5] == "clean" && r[6] != "z" }
z_orphans = results.select { |r| r[2] == "0" && r[6] == "z" }
covered_by_skill = results.select { |r| r[2] != "-" && r[4] != "-" && r[4] != "clean" }

puts "Total commands: #{results.size}"
puts "Orphans (0 cross-refs, no stale paths): #{orphans.size}"
orphans.each { |r| puts "  - #{r[0]}: #{r[1]}" }
puts
puts "Z-prefixed orphans: #{z_orphans.size}"
z_orphans.each { |r| puts "  - #{r[0]}: #{r[1]}" }
puts
puts "Covered by matching skill: #{results.count { |r| r[4] != "-" }}"
results.select { |r| r[4] != "-" }.each { |r| puts "  - #{r[0]} → skill: #{r[4]}" }
puts
puts "Commands with stale paths: #{results.count { |r| r[5] != "clean" }}"
results.select { |r| r[5] != "clean" }.each { |r| puts "  - #{r[0]}: #{r[5]}" }

puts
puts "--- Archive candidates (orphan + skill-covered + z-prefix) ---"
puts
archive_candidates = results.select { |r| r[2] == "0" }
archive_candidates.each do |r|
  reasons = []
  reasons << "z-prefixed" if r[6] == "z"
  reasons << "covered by skill: #{r[4]}" if r[4] != "-"
  reasons << "no cross-refs" if r[2] == "0"
  reasons << "stale path: #{r[5]}" if r[5] != "clean"
  puts "  #{r[0]}: #{reasons.join(", ")}"
end
