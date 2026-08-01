#!/usr/bin/env ruby
# ring: 1 (DB-READ) — protocol reference scope
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
  next unless e[:type] == "protocols"

  refs = e[:references]
  next unless refs.is_a?(Array) && !refs.empty?

  refs.each do |rid|
    target_ring = IdToRing.call(rid.to_s)
    unless target_ring
      violations << [e[:id], rid.to_s, "unresolvable", "-",
        "cannot resolve target entity"]
      next
    end

    tg = target_ring[:group]

    # Allowed: encyclopedic OR sibling protocol (architectonic R4)
    if tg == :encyclopedic
      # valid — protocol may reference encyclopedic entities
    elsif tg == :architectonic && target_ring[:ring] == 4
      # valid — sibling protocol
    else
      violations << [e[:id], rid.to_s, target_ring[:group].to_s, "R#{target_ring[:ring]}",
        "protocol references #{target_ring[:group]} R#{target_ring[:ring]} — must be encyclopedic or sibling protocol"]
    end
  end
end

if violations.empty?
  puts "ok — all protocols compliant: references target encyclopedic or sibling protocols only"
else
  puts "protocol reference violations (#{violations.size}):"
  puts Table.call(violations, %w[Protocol Reference TargetGroup TargetRing Violation])
end
