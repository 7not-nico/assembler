#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — detect composition claims in protocols and patterns
# survey: tool-layer-survey
# Rules:
#   - Only nexus states composition (what composes with what, layer roles)
#   - Protocols state contracts (schema, fields, invariants, enforcement)
#   - Patterns state morphisms (transformation, recognition, generation)

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

# Tool-layer composition keywords — these signal which layer does what (nexus-only)
LAYER_COMPOSITION_KEYWORDS = /\b(?:deployment\s+layer|fallback\s+tier|serves\s+as\s+(?:a\s+)?(?:fallback|read|write|primary)|primary\s+(?:read|write)\s+layer\b|(?:MCP|CLI|IPC|Plugin|Script)\s+(?:layer|tier|server|tool)\s+(?:is|serves|acts)|choose\s+(?:CLI|MCP|IPC|Plugin|Script)\s+(?:over|when|for)|use\s+(?:MCP|CLI|IPC|Plugin|Script)\s+for\s+(?:read|write|query)|(?:read|write)\s+(?:layer|tier)\s+(?:is|uses|belongs)|classification\s+orthogonal\s+to\s+deployment|parallel\s+to\s+Custom\s+IPC|subproject\s+permits|root\s+permits)\b/i

# Morphism keywords
MORPHISM_KEYWORDS = /\b(?:morph(?:ism|ic)?|trans(?:form|duce)|recognize|generate|signal|RECG|TRNS|GENR|SGNL|I\/O\s+(?:behavior|model|class)|automaton)\b/i

violations = []

scan_body = ->(text) {
  b = text.dup
  b.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
  b.sub!(/---\s*\n.*?\n---\s*\z/m, "")
  b
}

# === PROTOCOLS: flag composition claims ===
Dir[EntityGlob.call("protocols")].each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  body = scan_body.call(text)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s

  body.lines.each_with_index do |line, i|
    next if line.strip.empty?
    next if line.strip.start_with?("- `") || line.strip.start_with?("  - `")
    next if line =~ /^\s*\|.*\|$/ && !line.include?("compose") && !line.include?("fallback")
    if line.match?(LAYER_COMPOSITION_KEYWORDS)
      violations << [rel, base, "protocol", "COMPOSITION", (i+1).to_s, line.strip[0..100]]
    end
  end
end

# === PROTOCOLS: also check summary/protocol frontmatter fields ===
Dir[EntityGlob.call("protocols")].each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  meta = ParseFrontmatter.call(text)
  next unless meta

  [:summary, :protocol].each do |field|
    val = meta[field].to_s
    if val.match?(LAYER_COMPOSITION_KEYWORDS)
      violations << [rel, base, "protocol", "COMPOSITION(fm)", field.to_s, val[0..100]]
    end
  end
end

# === PATTERNS: flag composition claims ===
Dir[EntityGlob.call("patterns")].each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  body = scan_body.call(text)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s

  body.lines.each_with_index do |line, i|
    next if line.strip.empty?
    if line.match?(LAYER_COMPOSITION_KEYWORDS)
      violations << [rel, base, "pattern", "COMPOSITION", (i+1).to_s, line.strip[0..100]]
    end
  end
end

# === NEXUS: verify they DO state composition (expected, flagged only if missing) ===
nexus_composition_count = 0
Dir[EntityGlob.call("nexus")].each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  body = scan_body.call(text)
  meta = ParseFrontmatter.call(text)

  comp = (meta && meta[:composition]).to_s
  if body.match?(LAYER_COMPOSITION_KEYWORDS) || comp.match?(LAYER_COMPOSITION_KEYWORDS)
    nexus_composition_count += 1
  end
end

# === PATTERNS: verify they state morphisms ===
pattern_morphism_count = 0
Dir[EntityGlob.call("patterns")].each do |path|
  text = File.read(path)
  meta = ParseFrontmatter.call(text)
  principle = (meta && meta[:principle]).to_s
  body = scan_body.call(text)

  if body.match?(MORPHISM_KEYWORDS) || principle.match?(MORPHISM_KEYWORDS)
    pattern_morphism_count += 1
  end
end

# === OUTPUT ===
puts "=== Entity Boundary Violations ==="
puts
puts "Rules:"
puts "  Only nexus  → COMPOSITION (what composes, layer roles, fallback tiers)"
puts "  Protocols   → CONTRACT (schema, fields, invariants, enforcement)"
puts "  Patterns    → MORPHISM (transformation, recognition, generation)"
puts

if violations.empty?
  puts "  CLEAN — 0 violations found"
else
  by_type = violations.group_by { |v| v[2] }.sort
  by_type.each do |type, group|
    puts "--- #{type.upcase} — #{group.size} violations ---"
    puts

    by_vtype = group.group_by { |v| v[3] }.sort
    by_vtype.each do |vtype, vgroup|
      puts "  #{vtype}:"
      vgroup.each do |v|
        puts "    #{v[0]}:#{v[4]}"
        puts "      #{v[5]}"
        puts
      end
    end
  end
end

puts "=== Summary ==="
puts
puts "  Protocol composition violations: #{violations.count { |v| v[2] == "protocol" && v[3] == "COMPOSITION" }}"
puts "  Pattern composition violations:  #{violations.count { |v| v[2] == "pattern" && v[3] == "COMPOSITION" }}"
puts "  Nexus stating composition:       #{nexus_composition_count} / #{Dir[EntityGlob.call("nexus")].size}"
puts "  Patterns stating morphisms:      #{pattern_morphism_count} / #{Dir[EntityGlob.call("patterns")].size}"
puts
puts "Affected files: #{violations.map { |v| v[0] }.uniq.size}"
