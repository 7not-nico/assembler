# s02-crossref-impact.rb — classify and update each cross-ref
# ring: 1 (LOCAL-READ)
# non-write

require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

CROSSREFS = [
  { file: "IDENTITY.MAXIM.md", type: "identity", line: 19,
    current: "REF.MAXIM.LINE.JUNCTION — line junction notation",
    action: "add SPEC.MAXIM.LINE.JUNCTION entry" },
  { file: "PROT.MAXIM.IDENTITY.md", type: "protocol", line: 7,
    current: "reference: REF.MAXIM.LINE.JUNCTION",
    action: "replace with reference: SPEC.MAXIM.LINE.JUNCTION" },
  { file: "PROT.MAXIM.IDENTITY.md", type: "protocol", line: 71,
    current: "`REF.MAXIM.LINE.JUNCTION` — line-junction notation specification",
    action: "replace with `SPEC.MAXIM.LINE.JUNCTION`" },
  { file: "PROT.RULE.IDENTITY.md", type: "protocol", line: 11,
    current: "reference: REF.MAXIM.LINE.JUNCTION",
    action: "replace with reference: SPEC.MAXIM.LINE.JUNCTION" },
]

puts "=== Cross-Reference Impact ==="
puts ""
CROSSREFS.each do |r|
  puts "#{r[:type].ljust(10)} #{r[:file].ljust(30)} line #{r[:line].to_s.ljust(3)} #{r[:action]}"
end
puts ""
puts "Total updates: #{CROSSREFS.size}"
