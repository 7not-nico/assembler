#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — analyze ring placement for SPEC.* entities
# survey: specification-migration

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/entity"
require_relative "../../_rb/patlib"
require_relative "../../_rb/rings"
require_relative "../../_rb/report"

CANDIDATES = %w[MAX.KNOWLEDGE.CLASSIFICATION MAX.ENTITY.ONTOLOGY MAX.ENTITY.DISCERNIBILITY MAX.ENTITY.RECLASSIFY].freeze

current_ring = TypeToRing.call("maxims")
entries = LoadAllEntities.call

puts "=== Ring Placement Analysis ==="
puts
puts "Current MAX.* ring: #{current_ring[:group]} R#{current_ring[:ring]} (#{current_ring[:name]})"
puts

src_refs = []
entries.each do |e|
  src = e[:source].to_s
  next unless CANDIDATES.include?(src)
  er = TypeToRing.call(e[:type])
  next unless er
  src_refs << [e[:id], e[:type], er[:group], er[:ring], src]
end

puts "--- Source References (entities sourcing MAX.*) ---"
puts
if src_refs.empty?
  puts "  (none)"
else
  puts "  #{Table.call(
    src_refs.map { |r| [r[0], r[1], "#{r[2]} R#{r[3]}", r[4]] },
    %w[Entity Type Ring Source]
  )}"
  puts
  src_refs.group_by { |r| r[4] }.each do |target, group|
    puts "  #{target}: #{group.size} source(s)"
  end
end
puts

ill_refs = []
Dir[EntityGlob.call("illustrations")].each do |path|
  base = File.basename(path, ".md")
  meta = ParseFrontmatter.call(File.read(path))
  next unless meta
  arr = Array(meta[:illustrates]).map(&:to_s)
  arr.each { |t| ill_refs << [base, t] if CANDIDATES.include?(t) }
end

puts "--- Illustration References ---"
puts
if ill_refs.empty?
  puts "  (none)"
else
  ill_refs.each do |ill, target|
    puts "  #{ill} illustrates #{target}"
  end
  puts
  puts "  Note: RUL.ILLUSTRATION.SCOPE restricts targets to patterns/nexus."
  puts "  These are pre-existing violations, unaffected by MAX→SPEC migration."
end
puts

rel_refs = []
entries.each do |e|
  rels = e[:related]
  next unless rels.is_a?(Array)
  rels.map(&:to_s).each do |rid|
    rel_refs << [e[:id], e[:type], rid] if CANDIDATES.include?(rid)
  end
end

puts "--- Related References ---"
puts
if rel_refs.empty?
  puts "  (none — 0 related refs, no isolation concern)"
else
  puts "  #{Table.call(rel_refs, %w[Entity Type Related])}"
end
puts

puts "--- Ring Options ---"
puts

options = [
  { ring: 0, name: "Maxim (Axiomatic)", same: true,
    pros: "Minimal change — same ring, every existing ref stays valid at the same ring distance.",
    cons: "R0 is the Axiomatic ring for universal truths. SPEC are system-definitions, not universal." },
  { ring: 1, name: "Abstraction (Structural)", same: false,
    pros: "System-definitions fit with abstractions (structural derivations). All current R1→R0 sources become same-ring R1→R1.",
    cons: "Requires RingGroups.rehash to add specifications at R1. Illustration refs cross R6→R1 (valid, same group)." },
  { ring: 2, name: "Rule (Operational)", same: false,
    pros: "System-definitions describe operational boundaries, close to rules conceptually.",
    cons: "R1→R2 outward sources (valid per r1-source-validate — only encyclopedic sources are constrained), but further from maxim origins." }
]

options.each do |o|
  puts "--- Option #{o[:ring] == current_ring[:ring] ? 'A' : o[:ring] == 1 ? 'B' : 'C'}: Architectonic R#{o[:ring]} (#{o[:name]}) ---"
  puts "  Pros: #{o[:pros]}"
  puts "  Cons: #{o[:cons]}"
  puts
end

puts "--- Conclusion ---"
puts
puts "All 3 options are technically valid: Architectonic→Architectonic source references"
puts "are unconstrained by r1-source-validate (only encyclopedic sources have ring direction rules)."
puts "Related isolation is not affected (0 related refs across all 4 candidates)."
puts
puts "Key differentiator: the nature of specifications. They define the system's structural"
puts "architecture — what types exist, at what rings, naming schemas, reclassification rules."
puts "This aligns with R1 (structural derivations) where abstractions and linguistics live."
puts "R0 alternative preserves minimal change but misaligns conceptually (R0 = axiomatic truths)."
puts "R2 alternative is valid but further from the conceptual origins."
puts
puts "Recommend: Option B (R1) — structural ring matches structural content."
puts "But present this to the user for decision."
