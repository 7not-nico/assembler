# s01-inventory.rb — list existing vs missing IDENTITY.* entities
# ring: 1 (LOCAL-READ)
# non-write

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
DIR = ROOT.join(".opencode", "entities", "identities")
SPEC = ROOT.join(".opencode", "entities", "specifications", "SPEC.KNOWLEDGE.CLASSIFICATION.md")

existing = Dir[DIR.join("IDENTITY.*.md")].map { |f| File.basename(f, ".md").sub("IDENTITY.", "") }

# All entity types that should have an identity
all_types = %w[
  PROTOCOL COMMAND PATTERN NEXUS PERSON REFERENCE ILLUSTRATION
  COGNITION CONCEPT DEFINITION TAXONOMY BIOLOGY CHEMISTRY
  TERM MAXIM RULE SKILL SPECIFICATION
  KNOWLEDGE SCHEMA SURVEY YAML META
]

missing = all_types - existing

puts "=== Identity Inventory ==="
puts ""
puts "Existing (#{existing.size}): #{existing.sort.join(', ')}"
puts ""
puts "Missing (#{missing.size}): #{missing.sort.join(', ')}"
puts ""

puts "New identities to create:"
missing.sort.each do |t|
  info = type_info(t)
  puts "  IDENTITY.#{t.ljust(15)} #{info[:group].ljust(15)} R#{info[:ring]}  #{info[:naming]}"
end

def type_info(type)
  case type
  when "PROTOCOL"    then { group: "architectonic", ring: 4, naming: "PROT.{DOMAIN}.{NAME}" }
  when "COMMAND"     then { group: "architectonic", ring: 1, naming: "CMD.{VERB}.{DOMAIN}" }
  when "PATTERN"     then { group: "architectonic", ring: 5, naming: "PAT.{DOMAIN}.{SUBJECT}" }
  when "NEXUS"       then { group: "architectonic", ring: 3, naming: "NEX.{DOMAIN}.{SUBJECT}" }
  when "PERSON"      then { group: "chronicle",     ring: 0, naming: "PER.{NAMESPACE}.{NAME}" }
  when "REFERENCE"   then { group: "architectonic", ring: 6, naming: "REF.{DOMAIN}.{TOPIC}" }
  when "BIOLOGY"     then { group: "encyclopedic",  ring: 3, naming: "BIO.{GENUS}.{SPECIES}" }
  when "CHEMISTRY"   then { group: "encyclopedic",  ring: 3, naming: "CHEM.{CLASSIFICATION}.{NAME}" }
  when "META"        then { group: "encyclopedic",  ring: 3, naming: "IDENTITY.{DOMAIN}.{SUBJECT}" }
  else { group: "unknown", ring: "?", naming: "?" }
  end
end
