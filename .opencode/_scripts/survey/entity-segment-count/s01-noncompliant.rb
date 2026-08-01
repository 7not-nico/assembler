# s01-noncompliant.rb — list entities with segments below group minimum
# ring: 1 (LOCAL-READ)
# non-write

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

# min_segments: Axiomatic = 4, Composition = 3
TYPES = {
  maxims:         { prefix: "MAX",  group: "axiomatic",   dir: ".opencode/entities/maxims",         min_segments: 4 },
  specifications: { prefix: "SPEC", group: "axiomatic",   dir: ".opencode/entities/specifications",  min_segments: 4 },
  protocols:      { prefix: "PROT", group: "composition", dir: ".opencode/entities/protocols",      min_segments: 3 },
  patterns:       { prefix: "PAT",  group: "composition", dir: ".opencode/entities/patterns",       min_segments: 3 },
  nexus:          { prefix: "NEX",  group: "composition", dir: ".opencode/entities/nexus",          min_segments: 3 },
  illustrations:  { prefix: "ILL",  group: "composition", dir: ".opencode/entities/illustrations",  min_segments: 3 },
  references:     { prefix: "REF",  group: "composition", dir: ".opencode/entities/references",     min_segments: 3 },
}

MIN = ->(info) { info[:min_segments] }
puts "=== Non-Compliant Entities (below minimum segments per group) ==="
puts "  Axiomatic ≤3 segs  |  Composition ≤2 segs"
puts ""

total = 0
TYPES.each do |type, info|
  path = ROOT.join(info[:dir])
  next unless path.exist?
  Dir[path.join("*.md")].sort.each do |f|
    text = File.read(f)
    parts = text.split(/^---$/).reject(&:empty?)
    yml = YAML.safe_load(parts[0].strip) rescue {}
    id = yml["id"] || File.basename(f, ".md")
    segs = id.to_s.split(".").size
    next if segs >= MIN.call(info)
    total += 1
    puts "  #{id.ljust(50)} #{segs} segs  [#{type}]"
  end
end

puts ""
puts "Total non-compliant: #{total}"
