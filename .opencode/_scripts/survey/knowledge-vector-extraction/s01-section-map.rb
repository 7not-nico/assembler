# s01-section-map.rb — map SPEC.KNOWLEDGE.CLASSIFICATION sections
# ring: 1 (LOCAL-READ)
# depends-on: ../_rb/loader
# non-write

require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
FILE = ROOT.join(".opencode", "entities", "specifications", "SPEC.KNOWLEDGE.CLASSIFICATION.md")

text = File.read(FILE)
lines = text.split("\n")

puts "=== SPEC.KNOWLEDGE.CLASSIFICATION — Section Map ==="
puts ""

sections = []
current = nil

lines.each_with_index do |line, i|
  if line.start_with?("## ")
    current = { header: line.sub("## ", ""), start: i + 1, content: [] }
    sections << current
  elsif line.start_with?("---") && current
    current[:end] = i
    break
  elsif current
    current[:content] << line
  end
end

# Calculate end for last section before ---
sections.each do |sec|
  sec[:end] ||= lines.size
  sec[:content] = lines[sec[:start]..[sec[:end] - 1, lines.size - 1].min].reject(&:empty?)
  chars = sec[:content].sum(&:size)
  puts "  #{sec[:header]}"
  puts "    lines #{sec[:start]}-#{sec[:end]} (#{sec[:end] - sec[:start] + 1} lines, #{chars} chars)"
  puts "    classification: #{classify(sec[:header])}"
  puts ""
end

def classify(header)
  case header
  when "Groups" then "ring-topology"
  when "Vectors" then "vector-semantics"
  when "Capabilities" then "vector-semantics"
  when "Rules" then "both (ring-topology rules + vector-semantics rules)"
  when "Applicability" then "both"
  else "unknown"
  end
end

puts "=== Summary ==="
puts "Sections: #{sections.size}"
puts "Move to K.VECTOR: #{sections.count { |s| classify(s[:header]).start_with?("vector") }}"
puts "Keep in K.CLASSIFICATION: #{sections.count { |s| !classify(s[:header]).start_with?("vector") }}"
