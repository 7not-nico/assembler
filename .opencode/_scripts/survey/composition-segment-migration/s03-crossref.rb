#!/usr/bin/env ruby
# s03-crossref.rb — update all cross-references to old Composition entity IDs
# ring: 4 (LOCAL-WRITE) — edits cross-references in all .md files

require "yaml"
require "pathname"
require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

# Build old→new ID mapping from current entity files' frontmatter
# (files already renamed, so we read id: from each file)
DIRS = {
  protocols:      ".opencode/entities/protocols",
  patterns:       ".opencode/entities/patterns",
  nexus:          ".opencode/entities/nexus",
  illustrations:  ".opencode/entities/illustrations",
  references:     ".opencode/entities/references",
}

# Read current IDs (already renamed) — no old IDs remain in files
# Instead, the OLD filenames are now gone. We need the old→new mapping.
# Re-derive it from the rename pattern: 4-seg id → 3-seg id by dropping middle segments.

# Build reverse map: for any old 4-seg ID, compute its new 3-seg form.
# This is the same logic as s02-migrate but applied to cross-references in text.

COLLISION_MAP = {
  "ILL.MCP.SETUP" => ["ILL.MCP.DISCOVERY.SETUP", "ILL.MCP.TRANSPORT.SETUP"],
  "ILL.META.MAP" => ["ILL.META.ROUTING.MAP", "ILL.META.STRATUM.MAP"],
  "ILL.META.WALK" => ["ILL.META.DECISION.WALK", "ILL.META.TOPOLOGY.WALK"],
  "ILL.PERSON.CREATE" => ["ILL.PERSON.EVENT.CREATE", "ILL.PERSON.TIMELINE.CREATE"],
}

# Build old→new map
old_to_new = {}

COLLISION_MAP.each do |_collided, old_ids|
  old_ids.each do |oid|
    parts = oid.split(".")
    new_id = "#{parts[0]}.#{parts[1]}.#{parts[2]}"
    old_to_new[oid] = new_id
  end
end

# For non-collision entities, pattern is: PREFIX.DOMAIN.SUBJECT.ASPECT → PREFIX.DOMAIN.ASPECT
# Pre-compute all possible 4-segment composition IDs from the current 3-segment IDs
# Actually, we need the INVERSE: we need to know the OLD 4-segment IDs that people might still reference.
# Since we can't read old filenames (they're gone), we use the rule-based mapping:
# Any 4-segment ID matching PROT|PAT|NEX|ILL|REF gets the middle segments collapsed.

PREFIXES = %w[PROT PAT NEX ILL REF]

def compute_new_id(old_id)
  parts = old_id.split(".")
  return old_id unless parts.size >= 4
  prefix = parts[0]
  return old_id unless PREFIXES.include?(prefix)
  
  # Check collision map first
  if COLLISION_MAP[old_id]
    # Already handled above
    return old_id
  end
  
  "#{parts[0]}.#{parts[1]}.#{parts[-1]}"
end

# Scan all .md files for old IDs
puts "=== Cross-Reference Update ==="
puts "Scanning all .md files for old 4-segment Composition IDs..."
puts ""

total_replacements = 0
modified_files = 0
old_ids_found = {}  # old_id => [file, line_count]

# Collect all unique old IDs from file content
Dir[ROOT.join("**", "*.md")].sort.each do |f|
  next if f.to_s.include?("_scripts/") && !f.to_s.include?("composition-segment-migration")
  next if f.to_s.include?(".opencode/reports/")
  next if f.to_s.include?("node_modules/")
  
  text = File.read(f)
  modified = false
  
  # Find all potential old IDs: 4+ segment strings starting with PROT|PAT|NEX|ILL|REF
  text.gsub!(/\b(PROT|PAT|NEX|ILL|REF)((?:\.[A-Z][A-Z0-9.\/-]*){3,})\b/) do |match|
    old_id = match
    prefix = $1
    rest = $2
    
    # Build full ID
    # Match might already be full ID
    parts = old_id.split(".")
    
    # Skip if already 3 segments
    next match unless parts.size >= 4
    
    # Check collision map
    if COLLISION_MAP.key?(old_id)
      # Collision: look up specific mapping
      new_id = old_to_new[old_id]
      if new_id
        (old_ids_found[old_id] ||= []) << [f.to_s, 0]
        total_replacements += 1
        modified = true
        next new_id
      end
    end
    
    # Compute new ID: PREFIX.DOMAIN.ASPECT
    new_id = "#{parts[0]}.#{parts[1]}.#{parts[-1]}"
    
    (old_ids_found[old_id] ||= []) << [f.to_s, 0]
    total_replacements += 1
    modified = true
    new_id
  end
  
  if modified
    File.write(f, text)
    modified_files += 1
  end
end

puts "Files modified: #{modified_files}"
puts "Total replacements: #{total_replacements}"

# Print summary of what was found
puts ""
puts "Old IDs replaced (sample):"
old_ids_found.keys.sort.take(30).each do |oid|
  files = old_ids_found[oid].map { |f, _| Pathname.new(f).relative_path_from(ROOT).to_s }.uniq
  puts "  #{oid} → #{files.size} file(s)"
end

if old_ids_found.size > 30
  puts "  ... and #{old_ids_found.size - 30} more"
end

puts ""
puts "Cross-reference update complete."
