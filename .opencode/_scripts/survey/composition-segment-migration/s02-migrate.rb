#!/usr/bin/env ruby
# s02-migrate.rb — rename Composition entity IDs to 3-segment format
# ring: 4 (LOCAL-WRITE) — renames files, edits frontmatter
# CAUTION: modifies files in place. Run s01-map-ids.rb first to preview.

require "yaml"
require "pathname"
require "fileutils"
require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

DIRS = {
  protocols:      ".opencode/entities/protocols",
  patterns:       ".opencode/entities/patterns",
  nexus:          ".opencode/entities/nexus",
  illustrations:  ".opencode/entities/illustrations",
  references:     ".opencode/entities/references",
}

# Pass 1: Collect all entities with old_id and segs
entities = {}  # old_id => { path:, type:, segs:, parts_a: }
collisions = {}  # new_id => [old_id, ...]

DIRS.each do |type, dir|
  path = ROOT.join(dir)
  Dir[path.join("*.md")].sort.each do |f|
    text = File.read(f)
    fm = ParseFrontmatter.call(text)
    next unless fm && fm[:id]
    old_id = fm[:id]
    segs = old_id.split(".").size
    next if segs <= 3

    parts_a = old_id.split(".")
    proposed = "#{parts_a[0]}.#{parts_a[1]}.#{parts_a[-1]}"

    entities[old_id] = { path: f, type: type, segs: segs, parts: parts_a, proposed: proposed }
    (collisions[proposed] ||= []) << old_id
  end
end

# Pass 2: Resolve collisions — entities sharing proposed need DOMAIN.SUBJECT
resolved = {}  # old_id => new_id
collisions.each do |proposed, old_ids|
  if old_ids.size == 1
    resolved[old_ids[0]] = proposed
  else
    $stderr.puts "COLLISION on #{proposed}: #{old_ids.inspect}"
    old_ids.each do |oid|
      parts = oid.split(".")
      alt = "#{parts[0]}.#{parts[1]}.#{parts[2]}"
      # Verify alt does not itself collide with any proposed or other resolved
      if resolved.values.include?(alt) || collisions.key?(alt)
        $stderr.puts "  SECONDARY COLLISION on #{alt}, using full old_id: #{oid}"
        alt = oid  # keep full 4-segment as last resort
      end
      resolved[oid] = alt
      $stderr.puts "  #{oid} → #{alt}"
    end
  end
end

# Pass 3: Verify no new collisions introduced by resolution
new_ids = resolved.values
dup = new_ids.select { |id| new_ids.count(id) > 1 }.uniq
unless dup.empty?
  $stderr.puts "FATAL: Unresolved collisions remain: #{dup.inspect}"
  exit 1
end

# Pass 4: Perform migration
puts "=== Composition Group Segment Migration ==="
puts "#{resolved.size} entities to rename"
puts ""

count_rename = 0
resolved.each do |old_id, new_id|
  entry = entities[old_id]
  old_path = entry[:path]
  new_basename = new_id + ".md"
  new_path = File.join(File.dirname(old_path), new_basename)

  # Update frontmatter id field
  text = File.read(old_path)
  fm_updated = text.sub(/^id:\s*.+/, "id: #{new_id}")
  File.write(old_path, fm_updated)

  # Rename file
  if old_path != new_path.to_s
    FileUtils.mv(old_path, new_path)
    count_rename += 1
    puts "  %-55s → %-45s RENAME" % [old_id, new_id]
  else
    puts "  %-55s → %-45s SAME" % [old_id, new_id]
  end
end

puts ""
puts "Migration complete: #{resolved.size} updated, #{count_rename} files renamed."
puts "NEXT: Run s03-crossref.rb to update cross-references."
