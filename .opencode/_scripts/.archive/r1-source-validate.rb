#!/usr/bin/env ruby
# ring: 1 (DB-READ) — source vector validation
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/rings, _rb/entity, _rb/patlib

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/rings"
require_relative "_rb/entity"
require_relative "_rb/patlib"

entries = LoadAllEntities.call

violations = []

entries.each do |e|
  src = e[:source]
  next unless src.is_a?(String) && !src.empty?
  next unless src.match?(PATLIB_ID)

  src_ring = SourceToRing.call(src)
  entity_ring = TypeToRing.call(e[:type])

  next unless src_ring && entity_ring

  eg = entity_ring[:group]
  sg = src_ring[:group]
  er = entity_ring[:ring]
  sr = src_ring[:ring]

  # Rule 1: encyclopedic never sources architectonic or chronicle
  if eg == :encyclopedic && (sg == :architectonic || sg == :chronicle)
    violations << [e[:id], e[:type], src, eg.to_s, sg.to_s,
      "encyclopedic sources #{sg} — violates outer→inner direction"]
    next
  end

  # Rule 2: encyclopedic source should point to same or inner ring
  if eg == :encyclopedic && sg == :encyclopedic
    if sr > er
      violations << [e[:id], e[:type], src, "R#{er}", "R#{sr}",
        "encyclopedic source at outer ring R#{sr} > entity ring R#{er}"]
    end
  end

  # Rule 3: chronicle sources any except itself (no restriction per se)
  # Rule 4: any entity may source encyclopedic (always valid)
  # Rule 5: source cannot be self
  if src == e[:id].to_s
    violations << [e[:id], e[:type], src, eg.to_s, sg.to_s,
      "source references self"]
  end
end

if violations.empty?
  puts "ok — #{entries.size} entities, 0 source direction violations"
else
  puts "source direction violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Source EntityRing SourceRing Violation])
end
