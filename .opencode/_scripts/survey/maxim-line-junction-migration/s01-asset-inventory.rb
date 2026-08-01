# s01-asset-inventory.rb — map REF.MAXIM.LINE.JUNCTION body for SPEC conversion
# ring: 1 (LOCAL-READ)
# non-write

require "yaml"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
REF = ROOT.join(".opencode", "entities", "references", "REF.MAXIM.LINE.JUNCTION.md")

text = File.read(REF)
parts = text.split(/^---$/).reject(&:empty?)

# Format: ---<frontmatter>---<body>
frontmatter = YAML.safe_load(parts[0].strip) rescue nil
if frontmatter.nil? || !frontmatter.key?("id")
  frontmatter = YAML.safe_load(parts[1].strip) rescue {}
  body = parts[2..].join("---").strip
else
  body = parts[1..].join("---").strip
end

puts "=== REF.MAXIM.LINE.JUNCTION — Asset Inventory ==="
puts ""

puts "Frontmatter fields (will drop in SPEC format):"
frontmatter.each { |k, v| puts "  #{k}: #{v.inspect}" }
puts ""
puts "Body sections:"
in_section = nil
body.split("\n").each do |l|
  if l.start_with?("## ")
    in_section = l.sub("## ", "")
    puts "  ## #{in_section}"
  end
end
puts ""
puts "Total lines: #{text.split("\n").size}"
puts "Body chars: #{body.size}"
puts ""

puts "=== SPEC.MAXIM.LINE.JUNCTION — Proposed Format ==="
puts ""
puts "Backmatter (no related:, no ref:):"
puts "  id: SPEC.MAXIM.LINE.JUNCTION"
puts "  title: Maxim Line Junction — Notation Semantics and Application"
puts "  source: assembler"
puts "  tags: [maxim, notation, line-semantics, convention, specification]"
puts "  status: active"
puts ""
puts "Body sections to keep from REF:"
puts "  ## Rationale"
puts "  ## Operators"
puts "  ## Junction rule"
puts "  ## Edge cases"
puts ""
puts "Body sections to NOT migrate:"
puts "  ## Comparison with alternative notations (nice-to-have, not system architecture)"
puts "  ## Evolution (narrative, not rule)"
puts "  ## See also (SPECs don't use See also)"
