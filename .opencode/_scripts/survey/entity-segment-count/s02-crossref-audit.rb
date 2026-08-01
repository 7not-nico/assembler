# s02-crossref-audit.rb — find all cross-refs to non-compliant IDs
# ring: 1 (LOCAL-READ)
# non-write

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

# Non-compliant IDs from s01
IDS = %w[
  MAX.ATOMIC.CONCERN MAX.BATCH.PROCESS MAX.BROKEN.WINDOW MAX.BUN.ONLY
  MAX.CODE.LAYERS MAX.DRY MAX.ORTHOGONALITY
  MAX.PLAYWRIGHT.STANDARD MAX.PRECEDENCE.DERIVATION MAX.PROGRAMMING.DELIBERATELY
  MAX.PROJECTION.DERIVATION MAX.RUBY.ONLY MAX.SAGE.ONLY MAX.STALL.ENGINE
  PROT.COGNITION.IDENTITY PROT.COMMAND PROT.CONCEPT.IDENTITY
  PROT.DEFINITION.IDENTITY PROT.ILLUSTRATION.IDENTITY PROT.KNOWLEDGE.DIRECTORY
  PROT.MAXIM.IDENTITY PROT.METADATA.STRATUM PROT.PERSON.ENTITY
  PROT.PLUGIN.CANDIDATE PROT.PLUGIN.DIRECTION PROT.PLUGIN.VALIDATION
  PROT.RULE.IDENTITY PROT.SKILL.IDENTITY PROT.SKILL.STATECLASS
  PROT.TAX.IDENTITY PROT.TERM.IDENTITY PROT.TOOL.CLASSIFICATION
  PROT.TOOL.MORPHISM
  SPEC.ENTITY.DISCERNIBILITY SPEC.ENTITY.ONTOLOGY SPEC.ENTITY.RECLASSIFY
  SPEC.KNOWLEDGE.CLASSIFICATION SPEC.KNOWLEDGE.VECTOR SPEC.METADATA.STRATUM
  SPEC.TOOL.CLASSIFICATION SPEC.TOOL.MORPHISM
  PAT.DEPENDENCY.SYNC PAT.LLM.SPECIFICATION PAT.TRACER.BULLETS
  NEX.ACQUIRE.BIORXIV NEX.LIB.HANDLER
]

puts "=== Cross-Reference Audit ==="
puts ""

total_refs = 0
IDS.sort.each do |id|
  # Search across all .md files
  refs = []
  Dir[ROOT.join("**", "*.md")].each do |f|
    next if f.to_s.include?(".opencode/reports/")
    next if f.to_s.include?("scripts/")
    File.read(f).each_line.with_index do |line, i|
      if line.include?(id)
        refs << "#{Pathname.new(f).relative_path_from(ROOT)}:#{i + 1}"
      end
    end
  end
  next if refs.empty?
  total_refs += refs.size
  puts "  #{id} (#{refs.size} refs)"
  refs.each { |r| puts "    #{r}" }
  puts ""
end

puts "Total cross-references: #{total_refs}"
