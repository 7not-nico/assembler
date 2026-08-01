#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — check current PrefixToType registrations and entity dirs
# migration: identities — verify the ground is clear for IDENTITY prefix

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/patlib"
require_relative "../../_rb/rings"
require_relative "../../_rb/report"

rows = []

# 1. Check if IDENTITY prefix already registered
if PrefixToType.key?("IDENTITY")
  rows << ["IDENTITY", "PrefixToType", "ALREADY REGISTERED", "maps to #{PrefixToType['IDENTITY']}"]
else
  rows << ["IDENTITY", "PrefixToType", "AVAILABLE", "not registered"]
end

# 2. Check if identities/ dir exists
identities_path = ENTITIES.join("identities")
if Dir.exist?(identities_path)
  count = Dir[File.join(identities_path, "*.md")].size
  rows << ["identities/", "directory", "EXISTS", "#{count} files"]
else
  rows << ["identities/", "directory", "AVAILABLE", "does not exist"]
end

# 3. List all entity dirs
EntityTypes.each do |t|
  rows << [t, "entity dir", "EXISTS", Dir[EntityGlob.call(t)].size.to_s + " files"]
end

# 4. List all PROT.*.IDENTITY files
Dir[EntityGlob.call("protocols")].each do |path|
  base = File.basename(path, ".md")
  if base.match?(/\.IDENTITY$/)
    rows << [base, "protocol identity", "FOUND", "candidate for IDENTITY.*"]
  end
end

puts "=== Migration Readiness: identities/ ==="
puts
puts Table.call(rows, %w[Name Type Status Detail])
puts
puts "Summary: #{rows.size} checks"
