# s01-inventory.rb — list each PROT→SPEC candidate and its atomic concern
# ring: 1 (LOCAL-READ)
# non-write

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
PDIR = ROOT.join(".opencode", "entities", "protocols")
SDIR = ROOT.join(".opencode", "entities", "specifications")

CANDIDATES = [
  { id: "PROT.META.PROTOCOL.IDENTITY", spec: "SPEC.META.PROTOCOL.SCHEMA", concern: "protocol metadata fields and body section conventions" },
  { id: "PROT.META.PROTOCOL.IDENTITY", spec: "SPEC.ENTITY.GROUP.NAMING", concern: "entity group naming (-ic suffix, plural directories) — extracted rules 2-3" },
  { id: "PROT.META.ENTITY.DISTINCTION", spec: "SPEC.META.ENTITY.DISTINCTION", concern: "content boundary between PROT/PAT/MAX/ILL entity types" },
  { id: "PROT.METADATA.STRATUM", spec: "SPEC.METADATA.STRATUM", concern: "superior vs hidden metadata boundary" },
  { id: "PROT.META.DOCUMENT.COMPOSITION", spec: "SPEC.META.DOCUMENT.COMPOSITION", concern: "guided composition framework for skills and commands" },
  { id: "PROT.TOOL.CLASSIFICATION", spec: "SPEC.TOOL.CLASSIFICATION", concern: "automata theory I/O model (RECG/TRNS/GENR/SGNL)" },
  { id: "PROT.TOOL.MORPHISM", spec: "SPEC.TOOL.MORPHISM", concern: "category theory morphism model for tools" },
  { id: "PROT.TOOL.INVOCATION.MODEL", spec: "SPEC.TOOL.INVOCATION.MODEL", concern: "shebang CLI vs Custom IPC invocation" },
  { id: "PROT.SCHEMA.MIGRATION.AUGMENT", spec: "SPEC.SCHEMA.MIGRATION.AUGMENT", concern: "additive-only DB migration rules" },
]

puts "=== PROT → SPEC Migration Inventory ==="
puts ""
CANDIDATES.each do |c|
  proto_file = PDIR.join("#{c[:id]}.md")
  spec_file = SDIR.join("#{c[:spec]}.md")
  proto_exists = proto_file.exist?
  spec_exists = spec_file.exist?
  status = if spec_exists
    "ALREADY CREATED"
  elsif proto_exists
    "READY"
  else
    "PROTOCOL NOT FOUND"
  end
  puts "  #{c[:spec].ljust(40)} #{c[:concern].ljust(55)} #{status}"
end
puts ""
puts "Total: #{CANDIDATES.size} candidates"
puts "Source protocols: #{CANDIDATES.map { |c| c[:id] }.uniq.size} unique"
puts "Target SPECs: #{CANDIDATES.size}"
