# s03-diff-preview.rb — show proposed K.VECTOR and stripped K.CLASSIFICATION
# ring: 1 (LOCAL-READ)
# depends-on: ../_rb/loader
# non-write

require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
FILE = ROOT.join(".opencode", "entities", "specifications", "SPEC.KNOWLEDGE.CLASSIFICATION.md")

text = File.read(FILE)

# Extract body (before first ---)
body = text.split(/^---$/)[0].strip
lines = body.split("\n")

# Find section boundaries
sec = {}
current = nil
lines.each_with_index do |l, i|
  if l.start_with?("## ")
    current = l.sub("## ", "").downcase.to_sym
    sec[current] = { start: i, lines: [] }
  elsif current
    sec[current][:lines] << l
  end
end

puts "=== Diff Preview ==="
puts ""

puts "--- SPEC.KNOWLEDGE.CLASSIFICATION (after strip) ---"
puts "Body keeps: Groups + first para + Applicability"
puts sec[:groups][:lines].first(3).map { |l| "  #{l}" }.join("\n")
puts "  ... (full Groups section stays)"
puts ""
puts "Stripped:"
%i[vectors capabilities rules].each do |s|
  next unless sec[s]
  puts "  ## #{s.capitalize} (#{sec[s][:lines].size} lines) → moves to SPEC.KNOWLEDGE.VECTOR"
end
puts ""

puts "--- SPEC.KNOWLEDGE.VECTOR (new spec) ---"
puts ""
vector_lines = (sec[:vectors][:lines] + [""] + sec[:capabilities][:lines] + [""] + sec[:rules][:lines])
vector_lines.each { |l| puts "  #{l}" }
puts ""
puts "--- Applicability ---"
sec[:applicability][:lines].first(2).each { |l| puts "  #{l}" }
puts ""

puts "=== Actions Required ==="
puts "1. Create .opencode/entities/specifications/SPEC.KNOWLEDGE.VECTOR.md"
puts "2. Strip lines #{sec[:vectors][:start] + 1}-#{sec[:rules][:lines].size + sec[:rules][:start]} from K.CLASSIFICATION"
puts "3. Update 9 identity backmatter refs: add SPEC.KNOWLEDGE.VECTOR entry"
puts "4. Update PROT.TERM.IDENTITY: 'vector points upward per SPEC.KNOWLEDGE.VECTOR'"
puts "5. Sync and validate"
