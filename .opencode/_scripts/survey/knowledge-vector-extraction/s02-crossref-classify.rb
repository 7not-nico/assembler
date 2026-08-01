# s02-crossref-classify.rb — classify each cross-ref as ring-topology, vector, or both
# ring: 1 (LOCAL-READ)
# depends-on: ../_rb/loader
# non-write

require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

# All cross-refs to SPEC.KNOWLEDGE.CLASSIFICATION (from exhaustive grep)
CROSSREFS = [
  # Identity backmatter reference: entries (9 files)
  { file: "IDENTITY.TERM.md",        type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.TAX.md",         type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.SPECIFICATION.md", type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.RULE.md",        type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.META.PROTOCOL.md", type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.MAXIM.md",       type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.DEFINITION.md",  type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.CONCEPT.md",     type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "IDENTITY.COGNITION.md",   type: "identity", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },

  # Protocol body refs (8 files)
  { file: "PROT.RULE.IDENTITY.md",     type: "protocol", ref: "Rules are Architectonic Ring 2 per SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },
  { file: "PROT.TAX.IDENTITY.md",      type: "protocol", ref: "Taxonomy at Ring 2 per SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },
  { file: "PROT.TERM.IDENTITY.md",     type: "protocol", ref: "vector points upward per SPEC.KNOWLEDGE.CLASSIFICATION", target: "vector-semantics" },
  { file: "PROT.META.PROTOCOL.IDENTITY.md", type: "protocol", ref: "every entity type in every group...per SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },
  { file: "PROT.MAXIM.IDENTITY.md",    type: "protocol", ref: "maxims are orthogonal per SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },
  { file: "PROT.DEFINITION.IDENTITY.md", type: "protocol", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "PROT.CONCEPT.IDENTITY.md",  type: "protocol", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },
  { file: "PROT.COGNITION.IDENTITY.md",type: "protocol", ref: "SPEC.KNOWLEDGE.CLASSIFICATION — groups, layers, vector rules", target: "both" },

  # Scripts
  { file: "scripts/s02-strip-report.rb", type: "script", ref: "covered by backmatter + SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },
  { file: "scripts/s02-convert-preview.rb", type: "script", ref: "MAX→SPEC rename mapping", target: "meta" },
  { file: "scripts/s01-impact-report.rb", type: "script", ref: "MAX→SPEC rename mapping", target: "meta" },
  { file: "scripts/AGENTS.md", type: "script", ref: "Ring mapping per SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },

  # Report
  { file: "report/2026-07-27T011744Z.md", type: "report", ref: "covered by backmatter + SPEC.KNOWLEDGE.CLASSIFICATION", target: "ring-topology" },
]

puts "=== Cross-Reference Classification ==="
puts ""
puts "Classifications: ring-topology (stay in K.CLASSIFICATION), vector-semantics (move to K.VECTOR), both (needs split), meta (MAX→SPEC history)"
puts ""

by_target = CROSSREFS.group_by { |r| r[:target] }

by_target.each do |target, refs|
  puts "Target: #{target} (#{refs.size} refs)"
  refs.each do |r|
    action = case target
    when "ring-topology" then "keep"
    when "vector-semantics" then "rewrite to K.VECTOR"
    when "both" then "split ref: K.CLASSIFICATION + K.VECTOR"
    when "meta" then "no change needed"
    end
    puts "  #{r[:type].ljust(10)} #{r[:file].ljust(35)} #{action}"
  end
  puts ""
end

puts "=== Action Summary ==="
puts "Keep (ring-topology only): #{by_target["ring-topology"]&.size.to_i}"
puts "Rewrite to K.VECTOR:      #{by_target["vector-semantics"]&.size.to_i}"
puts "Split ref (both):         #{by_target["both"]&.size.to_i}"
puts "No change (meta):         #{by_target["meta"]&.size.to_i}"
