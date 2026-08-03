#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — entity filename format: PREFIX.UPPERCASE.SEGMENTS.md, no underscores

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/report"

ID_PATTERN = /\A[A-Z][A-Z0-9]*(\.[A-Z][A-Z0-9]*)+\z/

violations = []

EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")

    if base.include?("_")
      violations << [base, type, "underscore", "contains '_'"]
    end

    if base.match?(/[a-z]/)
      violations << [base, type, "lowercase", "contains lowercase letter"]
    end

    unless base.match?(ID_PATTERN)
      violations << [base, type, "format", "does not match PREFIX.UPPER.SEGMENTS"]
    end
  end
end

if violations.empty?
  puts "ok — #{EntityTypes.size} entity types, 0 naming violations"
else
  puts "naming violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Violation Detail])
end
