#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey: drop PROT.*.IDENTITY, superseded by IDENTITY.*
# survey: protocol-identity-removal

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/patlib"
require_relative "../../_rb/report"

identity_ids = Dir[EntityGlob.call("identities")].map { |p|
  File.basename(p, ".md")
}

candidates = []
Dir[EntityGlob.call("protocols")].each do |path|
  base = File.basename(path, ".md")
  next unless base.match?(/\.IDENTITY$/)

  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  target = "IDENTITY." + base.sub(/^PROT\./, "").sub(/\.IDENTITY$/, "")
  has_identity = identity_ids.include?(target)

  candidates << [base, target, has_identity ? "✓" : "✗", fm[:title].to_s[0..45], fm[:enforcement].to_s, fm[:status].to_s]
end

puts "=== PROT.*.IDENTITY → IDENTITY.* Replacement Status ==="
puts
puts Table.call(candidates, %w[Protocol Target Identity? Title Enforcement Status])
puts
ready = candidates.select { |c| c[2] == "✓" }
not_ready = candidates.select { |c| c[2] == "✗" }
puts "#{candidates.size} total, #{ready.size} ready for removal, #{not_ready.size} missing IDENTITY.*"
