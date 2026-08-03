#!/usr/bin/env ruby
# ring: 1 (DB-READ) — related isolation validation
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
  rels = e[:related]
  next unless rels.is_a?(Array) && !rels.empty?

  entity_ring = TypeToRing.call(e[:type])
  next unless entity_ring

  rels.each do |rid|
    target_ring = IdToRing.call(rid.to_s)
    next unless target_ring

    if target_ring[:group] != entity_ring[:group]
      violations << [e[:id], e[:type], entity_ring[:group].to_s, entity_ring[:ring].to_s,
        rid.to_s, target_ring[:group].to_s, target_ring[:ring].to_s,
        "cross-group related: #{entity_ring[:group]} → #{target_ring[:group]}"]
    elsif target_ring[:ring] != entity_ring[:ring]
      violations << [e[:id], e[:type], entity_ring[:group].to_s, entity_ring[:ring].to_s,
        rid.to_s, target_ring[:group].to_s, target_ring[:ring].to_s,
        "cross-ring related: R#{entity_ring[:ring]} → R#{target_ring[:ring]}"]
    end
  end
end

if violations.empty?
  puts "ok — #{entries.size} entities, 0 related isolation violations"
else
  puts "related isolation violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Group Ring Related RelGroup RelRing Violation])
end
