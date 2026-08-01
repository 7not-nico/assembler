#!/usr/bin/env ruby
# ring: 1 (DB-READ) — illustration target validation
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/rings, _rb/entity, _rb/patlib

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/rings"
require_relative "_rb/entity"
require_relative "_rb/patlib"

entries = LoadAllEntities.call

allowed_types = %w[patterns nexus]
violations = []

entries.each do |e|
  next unless e[:type] == "illustrations"

  targets = e[:illustrates]
  next unless targets.is_a?(Array) && !targets.empty?

  targets.each do |tid|
    ttype = IdToType.call(tid.to_s)

    unless ttype
      violations << [e[:id], tid.to_s, "unresolvable",
        "cannot resolve target type from ID"]
      next
    end

    unless allowed_types.include?(ttype)
      violations << [e[:id], tid.to_s, ttype,
        "illustrated entity is #{ttype} — only patterns/nexus allowed"]
    end
  end
end

if violations.empty?
  puts "ok — all illustrations target patterns or nexus only"
else
  puts "illustration target violations (#{violations.size}):"
  puts Table.call(violations, %w[Illustration Target TargetType Violation])
end
