#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify every protocol, pattern, nexus against its identity definition
# survey: tool-layer-survey
# 3 batches: protocols → patterns → nexus

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"
require_relative "../../_rb/entity"

LAYER_COMPOSITION_RE = /\b(?:deployment\s+layer|fallback\s+tier|serves\s+as\s+(?:a\s+)?(?:fallback|read|write|primary)|primary\s+(?:read|write)\s+layer|(?:MCP|CLI|IPC|Plugin|Script)\s+(?:layer|tier|server|tool)\s+(?:is|serves|acts)|choose\s+(?:CLI|MCP|IPC|Plugin|Script)\s+(?:over|when|for)|use\s+(?:MCP|CLI|IPC|Plugin|Script)\s+for\s+(?:read|write|query)|(?:read|write)\s+(?:layer|tier)\s+(?:is|uses|belongs)|classification\s+orthogonal\s+to\s+deployment|parallel\s+to\s+Custom\s+IPC|subproject\s+permits|root\s+permits)\b/i

MORPHISM_RE = /\b(?:morph(?:ism|ic)?|trans(?:form|duce)|recognize|generate|signal|RECG|TRNS|GENR|SGNL|I\/O\s+(?:behavior|model|class)|automaton)\b/i

COMPOSITION_BODY_RE = /\b(?:compose[sd]?|composition|layer[s]?\s+(?:choice|role|tier|layer)|pipeline|stack|binding|fallback\s+tier)\b/i

batch_results = []

# Build active entity index for source resolution
active_ids = {}
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    text = File.read(path)
    m = text.match(/^(?:---.*?---\n)?(?:.*?\n)?id:\s+(\S+)/m)
    active_ids[m[1]] = type if m
  end
end
active_ids["assembler"] = "root"

scan_body = ->(text) {
  b = text.dup
  b.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
  b.sub!(/---\s*\n.*?\n---\s*\z/m, "")
  b
}

sections_present = ->(body, *names) {
  names.map { |n| body.include?("## #{n}") }
}

# ========== BATCH 1: PROTOCOLS ==========
puts "=" * 72
puts "BATCH 1: PROTOCOLS (#{Dir[EntityGlob.call("protocols")].size})"
puts "=" * 72
puts

proto_results = []
Dir[EntityGlob.call("protocols")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  body = scan_body.call(text)
  meta = ParseFrontmatter.call(text)

  # Contract field
  has_protocol = meta && meta[:protocol] && !meta[:protocol].to_s.empty?

  # Sections
  sections = sections_present.call(body, "Protocol", "Gotchas", "Enforcement", "Applicability")
  section_count = sections.count(true)

  # First body line (meaningful)
  first_lines = body.lines.reject { |l| l.strip.empty? || l.strip.start_with?("##") }
  first_line = first_lines.first&.strip || "(empty)"

  # Composition claims
  composition_hits = []
  body.lines.each_with_index { |l, i| composition_hits << (i+1) if l.match?(LAYER_COMPOSITION_RE) }

  # Morphism claims
  morphism_hits = []
  body.lines.each_with_index { |l, i| morphism_hits << (i+1) if l.match?(MORPHISM_RE) }

  # Source resolution
  src = meta && (meta[:source] || meta["source"]).to_s
  src_ok = src.nil? || src.empty? || active_ids.key?(src)

  checks = []
  checks << (has_protocol ? "contract:OK" : "contract:MISSING")
  checks << (section_count >= 3 ? "sections:#{section_count}/4" : "sections:#{section_count}/4")
  checks << (composition_hits.empty? ? "composition:OK" : "composition:FAIL")
  checks << (src_ok ? "source:OK" : "source:UNRESOLVED")

  fail_count = checks.count { |c| c.include?("FAIL") || c.include?("MISSING") || c.include?("UNRESOLVED") }
  compliance = fail_count == 0 ? "PASS" : "FAIL"

  proto_results << [base, checks.join(" | "), compliance, first_line[0..90], composition_hits.empty? ? "" : "lines:#{composition_hits.join(",")}"]
end

proto_results.each do |r|
  if r[2] == "FAIL"
    puts "  FAIL  #{r[0].ljust(35)} #{r[1]}"
    puts "        #{r[3]}"
    puts "        #{r[4]}" unless r[4].empty?
  else
    puts "  PASS  #{r[0].ljust(35)} #{r[1]}"
  end
end

pass_count = proto_results.count { |r| r[2] == "PASS" }
fail_count = proto_results.count { |r| r[2] == "FAIL" }
puts
puts "  --- #{pass_count} PASS, #{fail_count} FAIL (total #{proto_results.size}) ---"
puts

batch_results << ["protocols", pass_count, fail_count, proto_results.size]

# ========== BATCH 2: PATTERNS ==========
puts "=" * 72
puts "BATCH 2: PATTERNS (#{Dir[EntityGlob.call("patterns")].size})"
puts "=" * 72
puts

pat_results = []
Dir[EntityGlob.call("patterns")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  body = scan_body.call(text)
  meta = ParseFrontmatter.call(text)

  has_principle = meta && meta[:principle] && !meta[:principle].to_s.empty?

  first_lines = body.lines.reject { |l| l.strip.empty? || l.strip.start_with?("##") }
  first_line = first_lines.first&.strip || "(empty)"

  morphism_hits = []
  body.lines.each_with_index { |l, i| morphism_hits << (i+1) if l.match?(MORPHISM_RE) }

  composition_hits = []
  body.lines.each_with_index { |l, i| composition_hits << (i+1) if l.match?(LAYER_COMPOSITION_RE) && !l.match?(MORPHISM_RE) }

  src = meta && (meta[:source] || meta["source"]).to_s
  src_ok = src.nil? || src.empty? || active_ids.key?(src)

  checks = []
  checks << (has_principle ? "principle:OK" : "principle:MISSING")
  checks << (morphism_hits.empty? ? "morphism:no" : "morphism:yes(#{morphism_hits.join(",")})")
  checks << (composition_hits.empty? ? "composition:OK" : "composition:FAIL")
  checks << (src_ok ? "source:OK" : "source:UNRESOLVED")

  fail_count = checks.count { |c| c.include?("FAIL") || c.include?("MISSING") }
  compliance = fail_count == 0 ? "PASS" : "FAIL"

  pat_results << [base, checks.join(" | "), compliance, first_line[0..90], composition_hits.empty? ? "" : "lines:#{composition_hits.join(",")}"]
end

pat_results.each do |r|
  if r[2] == "FAIL"
    puts "  FAIL  #{r[0].ljust(35)} #{r[1]}"
    puts "        #{r[3]}"
    puts "        #{r[4]}" unless r[4].empty?
  else
    puts "  PASS  #{r[0].ljust(35)} #{r[1]}"
  end
end

pass_count = pat_results.count { |r| r[2] == "PASS" }
fail_count = pat_results.count { |r| r[2] == "FAIL" }
puts
puts "  --- #{pass_count} PASS, #{fail_count} FAIL (total #{pat_results.size}) ---"
puts

batch_results << ["patterns", pass_count, fail_count, pat_results.size]

# ========== BATCH 3: NEXUS ==========
puts "=" * 72
puts "BATCH 3: NEXUS (#{Dir[EntityGlob.call("nexus")].size})"
puts "=" * 72
puts

nex_results = []
Dir[EntityGlob.call("nexus")].sort.each do |path|
  text = File.read(path)
  base = File.basename(path, ".md")
  body = scan_body.call(text)
  meta = ParseFrontmatter.call(text)

  has_composition = meta && meta[:composition] && !meta[:composition].to_s.empty?

  first_lines = body.lines.reject { |l| l.strip.empty? || l.strip.start_with?("##") }
  first_line = first_lines.first&.strip || "(empty)"

  body_composition = body.match?(COMPOSITION_BODY_RE)

  src = meta && (meta[:source] || meta["source"]).to_s
  src_ok = src.nil? || src.empty? || active_ids.key?(src)

  checks = []
  checks << (has_composition ? "comp-field:OK" : "comp-field:MISSING")
  checks << (body_composition ? "body:states" : "body:no-composition-lang")
  checks << (src_ok ? "source:OK" : "source:UNRESOLVED")

  fail_count = checks.count { |c| c.include?("MISSING") || c.include?("UNRESOLVED") || c.include?("no-composition") }
  compliance = fail_count == 0 ? "PASS" : "FAIL"

  nex_results << [base, checks.join(" | "), compliance, first_line[0..90]]
end

nex_results.each do |r|
  if r[2] == "FAIL"
    puts "  FAIL  #{r[0].ljust(35)} #{r[1]}"
    puts "        #{r[3]}"
  else
    puts "  PASS  #{r[0].ljust(35)} #{r[1]}"
  end
end

pass_count = nex_results.count { |r| r[2] == "PASS" }
fail_count = nex_results.count { |r| r[2] == "FAIL" }
puts
puts "  --- #{pass_count} PASS, #{fail_count} FAIL (total #{nex_results.size}) ---"
puts

batch_results << ["nexus", pass_count, fail_count, nex_results.size]

# ========== FINAL SUMMARY ==========
puts
puts "=" * 72
puts "COMPLIANCE SUMMARY"
puts "=" * 72
puts
puts "  #{Table.call(
  batch_results.map { |r| [r[0], r[3].to_s, r[1].to_s, r[2].to_s, "#{(r[1].to_f / r[3] * 100).round}%".rjust(4)] },
  %w[Type Total Pass Fail Rate]
)}"
puts
puts "  Key:"
puts "    Protocol violations = composition claims in contract body"
puts "    Pattern violations  = composition claims in morphism body"
puts "    Nexus violations    = missing composition field or body language"
