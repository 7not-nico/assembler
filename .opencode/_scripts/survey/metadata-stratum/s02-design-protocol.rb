#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — read MAX.METADATA.STRATUM + IDENTITY.YAML + IDENTITY.SCHEMA, draft PROT.METADATA.STRATUM
# survey: metadata-stratum — design the replacement protocol

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

DATA = {
  maxim: nil, yaml_id: nil, schema_id: nil
}

maxim_path = Dir[EntityGlob.call("maxims")].find { |p| File.basename(p, ".md") == "MAX.METADATA.STRATUM" }
if maxim_path
  DATA[:maxim] = ParseFrontmatter.call(File.read(maxim_path))
end
yaml_path = Dir[EntityGlob.call("identities")].find { |p| File.basename(p, ".md") == "IDENTITY.YAML" }
if yaml_path
  DATA[:yaml_id] = ParseBackmatter.call(File.read(yaml_path))
end
schema_path = Dir[EntityGlob.call("identities")].find { |p| File.basename(p, ".md") == "IDENTITY.SCHEMA" }
if schema_path
  DATA[:schema_id] = ParseBackmatter.call(File.read(schema_path))
end

puts "=== Proposed: PROT.METADATA.STRATUM ==="
puts
puts "Replaces: MAX.METADATA.STRATUM (maxim format violation — has tables)"
puts

puts "--- Protocol frontmatter ---"
puts
puts "id: PROT.METADATA.STRATUM"
puts "title: \"Metadata Stratum — Superior vs Hidden\""
puts "source: assembler"
if DATA[:maxim]
  puts "summary: \"#{DATA[:maxim][:summary].to_s[0..80]}\""
end
puts "protocol: \"Metadata has two strata: superior (authored YAML in any position) and hidden (derived from DDL and system registries). Superior is entity-specific, human-written, never structural. Hidden is type-wide, machine-derived, never in YAML. The boundary is architectural — crossing it duplicates invariants.\""
puts "enforcement: Convention"
puts "tags: [metadata, schema, derivation, identity, yaml, protocol]"
puts "status: active"
puts "priority: 2"
puts

puts "--- Protocol sections ---"
puts
puts "## Protocol"
puts
puts "### Stratum"
puts
puts "Superior metadata is authored YAML — frontmatter, backmatter, or standalone .yaml. Entity-specific, never structural. Hidden metadata is derived from DDL (_schemas/*.sql) and system registries (PrefixToType, RingGroups, ENTITY_FIELD_SPECS). Never in YAML. Shared across all entities of a type."
puts
puts "### Rules"
puts
puts "- Superior metadata never duplicates schema-level invariants (column names, types, constraints — those live in DDL)"
puts "- Hidden metadata never migrates to YAML — two representations of the same invariant violate MAX.DRY"
puts "- YAML position (frontmatter/backmatter) is a presentation convention determined by entity type, not a metadata stratum concern"
puts "- When schema changes, all entities of that type implicitly inherit the change — no YAML edits needed"
puts "- Verification scripts derive hidden metadata from canonical sources; if superior YAML contradicts hidden schema, schema prevails"
puts
puts "## Gotchas"
puts
puts "| Signal | Detection | Redirect |"
puts "|--------|-----------|----------|"
puts "| Schema field in YAML | YAML contains column names or type info | Remove — those belong in DDL alone |"
puts "| YAML position mismatch | Entity uses frontmatter when type convention is backmatter | Change to match entity type convention |"
puts "| Missing required field | Entity missing id, title, or source | Add required field to YAML |"
puts "| Stale schema | Entity file references field not in DDL | Run write-sync; schema migration may be needed |"
puts
puts "## Enforcement"
puts
puts "Survey scripts (identities-audit/a01-verify-completeness) check that superior metadata doesn't contradict schema. write-sync validates required fields per ENTITY_FIELD_SPECS."
puts
puts "## Applicability"
puts
puts "All entity types with both YAML and DDL. The boundary applies whenever authored metadata and schema-level structure coexist."
puts
puts "## See also"
puts
puts "- IDENTITY.YAML — superior metadata stratum identity"
puts "- IDENTITY.SCHEMA — hidden metadata stratum identity"
puts "- MAX.DRY — single source of truth (hidden metadata cannot be duplicated in YAML)"
puts "- PROT.META.PROTOCOL.IDENTITY — entity identity protocol pattern"
