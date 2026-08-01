#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey which entities declare tool layers and their roles
# survey: tool-layer-survey
# classifies each declaration as composition (nexus), contract (protocol), or morphism (pattern)

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

TOOL_LAYERS = %w[CLI IPC MCP Plugin Script].freeze
LAYER_PATTERN = /\b(?:CLI|Custom\s+IPC|MCP|Plugin|Script)\b/i

results = []

ScanDir = ->(dir, type_label) {
  Dir[dir].sort.each do |path|
    text = File.read(path)
    base = File.basename(path, ".md")
    rel = Pathname.new(path).relative_path_from(ROOT).to_s
    meta = ParseMetadata.call(text)

    # Remove backmatter/frontmatter for body scan
    body = text.dup
    body.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
    body.sub!(/---\s*\n.*?\n---\s*\z/m, "")

    # Check body for tool layer mentions
    matched = body.scan(LAYER_PATTERN).map(&:strip).uniq
    next if matched.empty?

    # Classify each matched layer
    normalized = matched.map { |m|
      case m
      when /CLI/i then "CLI"
      when /Custom\s+IPC/i then "IPC"
      when /MCP/i then "MCP"
      when /Plugin/i then "Plugin"
      when /Script/i then "Script"
      else m
      end
    }.uniq.sort

    # Extract key lines for context
    lines = body.lines
    key_indices = lines.each_with_index.select { |l, i|
      l.match?(LAYER_PATTERN) && !l.strip.start_with?("- `")
    }.map { |_, i| i }

    context = key_indices.first(3).map { |i| lines[i].strip }

    results << [base, type_label, normalized.join(", "), context.first(80).to_s]
  end
}

# 1. Nexuses — composition role
ScanDir.call(EntityGlob.call("nexus"), "nexus")

# 2. Protocols — contract role (flag if stating composition)
ScanDir.call(EntityGlob.call("protocols"), "protocol")

# 3. Patterns — morphism role
ScanDir.call(EntityGlob.call("patterns"), "pattern")

# 4. Specifications — definition role
ScanDir.call(EntityGlob.call("specifications"), "spec")

# 5. References — reference role
ScanDir.call(EntityGlob.call("references"), "ref")

# 6. Illustrations — walkthrough role
ScanDir.call(EntityGlob.call("illustrations"), "illustration")

puts "=== Tool Layer Declaration Survey ==="
puts
puts "Scanning for mentions of: CLI, IPC (Custom IPC), MCP, Plugin, Script"
puts "Entities scanned: #{EntityTypes.size} types"
puts

if results.empty?
  puts "  (no tool layer declarations found)"
else
  by_role = {
    "nexus" => "Composition",
    "protocol" => "Contract",
    "pattern" => "Morphism",
    "spec" => "Definition",
    "ref" => "Reference",
    "illustration" => "Walkthrough"
  }

  by_type = results.group_by { |r| r[1] }.sort
  by_type.each do |type, group|
    role = by_role[type] || "?"
    puts "--- #{type} (#{role}) — #{group.size} entities ---"
    puts
    group.each do |r|
      puts "  #{r[0]}".ljust(55) + "#{r[2]}"
      context_line = r[3].to_s
      puts "  #{' '.ljust(55)}#{context_line[0..90]}" unless context_line.empty?
      puts
    end
  end

  puts "=== Summary ==="
  puts
  puts "Total entities declaring tool layers: #{results.size}"

  by_type_summary = results.group_by { |r| r[1] }.map { |t, g| [t, g.size] }.sort
  by_type_summary.each { |t, c| puts "  #{t}: #{c}" }

  puts
  puts "--- Inconsistencies ---"
  puts

  # Check which entities include/exclude Script
  results.each do |r|
    layers = r[2].split(", ")
    missing = TOOL_LAYERS - layers
    unless missing.empty?
      puts "  #{r[0]} (#{r[1]}): declares [#{layers.join(", ")}], missing [#{missing.join(", ")}]"
    end
  end
end

puts
puts "=== NEXUS declarations (authoritative for composition) ==="
puts
nexus_results = results.select { |r| r[1] == "nexus" }
if nexus_results.empty?
  puts "  (none)"
else
  nexus_results.each do |r|
    puts "  #{r[0]}: #{r[2]}"
    puts "    #{r[3]}"
    puts
  end
end

puts "=== PROTOCOL declarations with composition implications ==="
puts
protocol_results = results.select { |r| r[1] == "protocol" }
if protocol_results.empty?
  puts "  (none)"
else
  protocol_results.each do |r|
    warning = r[2].include?(",") ? " (⚠ states multiple layers — check for composition claims)" : ""
    puts "  #{r[0]}: #{r[2]}#{warning}"
    puts "    #{r[3]}"
    puts
  end
end
