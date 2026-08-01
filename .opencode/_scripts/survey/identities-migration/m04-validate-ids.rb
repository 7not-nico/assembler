#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — validate proposed IDENTITY.* IDs against naming conventions
# migration: identities — ensures target IDs are well-formed before creation

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/patlib"
require_relative "../../_rb/report"

candidates = Dir[EntityGlob.call("protocols")].map { |p|
  File.basename(p, ".md")
}.select { |b| b.match?(/\.IDENTITY$/) }.map { |b|
  b.sub(/^PROT\./, "").sub(/\.IDENTITY$/, "")
}

violations = []
valid = []

candidates.each do |name|
  target_id = "IDENTITY.#{name}"
  m = target_id.match(PATLIB_ID)

  unless m
    violations << [target_id, "does not match PATLIB_ID pattern"]
    next
  end

  prefix = m[1]
  unless prefix == "IDENTITY"
    violations << [target_id, "prefix #{prefix} != IDENTITY"]
    next
  end

  type = PrefixToType[prefix]
  if type
    violations << [target_id, "prefix IDENTITY already registered → #{type}"]
    next
  end

  if target_id.include?("_")
    violations << [target_id, "contains underscore"]
    next
  end

  valid << [target_id, "well-formed", "prefix available"]
end

puts "=== IDENTITY.* ID Validation ==="
puts
unless valid.empty?
  puts "Valid (#{valid.size}):"
  puts Table.call(valid, %w[Target Status Detail])
  puts
end
unless violations.empty?
  puts "Violations (#{violations.size}):"
  puts Table.call(violations, %w[Target Problem])
  puts
end
puts "Total: #{candidates.size} candidates, #{valid.size} valid, #{violations.size} violations"
