#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify identity assignment for MAXIM, PRECEPT, SPEC
# survey: precept-migration

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"
require_relative "../../_rb/patlib"
require_relative "../../_rb/fields"

def check_external_source(source)
  return false if source.nil? || source.strip.empty?
  s = source.strip
  s.start_with?("INSP.") || s.include?(",") || s.include?("(")
end

def detect_field(meta, field)
  return nil unless meta
  v = meta[field]
  v.is_a?(String) && !v.strip.empty? ? v.strip : nil
end

violations = []

%w[maxims precepts specifications].each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    text = File.read(path)
    basename = File.basename(path, ".md")
    meta = ParseMetadata.call(text)

    id = meta ? meta["id"]&.strip : nil
    prefix = id ? id.split(".").first : nil
    source = detect_field(meta, "source")
    principle = detect_field(meta, "principle")
    precept = detect_field(meta, "precept")
    specifies = detect_field(meta, "specifies")

    # Body section detection
    body = text.dup
    body.sub!(/\A---\s*\n.*?\n---\s*\n?/m, "")
    body.sub!(/---\s*\n.*?\n---\s*\z/m, "")
    has_corollaries = body.match?(/^## Corollaries$/)
    has_rules = body.match?(/^## Rules$/)
    has_categorization = body.match?(/^## (Model|Toolchain|Runtime|Domain|Rhythm|Skills|Scope|Derivation|Change-Reasons|Decay|Expression|Debt|Purpose|Action|Knowledge|Axes|Representation)\b/)
    has_applicability = body.match?(/^## Applicability$/)

    if !meta
      violations << [id || basename, type, "ERROR", "no metadata"]
      next
    end

    case prefix
    when "MAX"
      if !principle
        violations << [id, type, "MISSING", "principle: field required"]
      end
      if !check_external_source(source)
        violations << [id, type, "SOURCE", "source '#{source}' is not external (INSP.* / citation)"]
      end
      if precept
        violations << [id, type, "CROSS", "has precept: field (belongs in PRE)"]
      end
      if specifies
        violations << [id, type, "CROSS", "has specifies: field (belongs in SPEC)"]
      end

    when "PRE"
      if !precept
        violations << [id, type, "MISSING", "precept: field required"]
      end
      if source != "assembler"
        violations << [id, type, "SOURCE", "source '#{source}' should be 'assembler'"]
      end
      if principle
        violations << [id, type, "CROSS", "has principle: field (belongs in MAX)"]
      end
      if specifies
        violations << [id, type, "CROSS", "has specifies: field (belongs in SPEC)"]
      end
      if !has_corollaries
        violations << [id, type, "MISSING", "missing ## Corollaries section"]
      end
      if has_categorization
        violations << [id, type, "STALE", "has categorization section (## #{body.match(/^## (Model|Toolchain|Runtime|Domain|Rhythm|Skills|Scope|Derivation)\b/)[1] rescue '?'})"]
      end

    when "SPEC"
      if !specifies
        violations << [id, type, "MISSING", "specifies: field required"]
      end
      if principle
        violations << [id, type, "CROSS", "has principle: field (belongs in MAX)"]
      end
      if precept
        violations << [id, type, "CROSS", "has precept: field (belongs in PRE)"]
      end
      if has_categorization
        violations << [id, type, "STALE", "has categorization section"]
      end
    end
  end
end

puts "=== Identity Assignment Survey ==="
puts
puts "Checked: MAXIMs=#{Dir[EntityGlob.call("maxims")].size} PRECEPTs=#{Dir[EntityGlob.call("precepts")].size} SPECs=#{Dir[EntityGlob.call("specifications")].size}"
puts

if violations.empty?
  puts "✅  0 violations — all 40 entities correctly assigned to their identities"
  puts
  puts "MAXIM:  #{Dir[EntityGlob.call("maxims")].size} files — all have external source + principle: field"
  puts "PRECEPT: #{Dir[EntityGlob.call("precepts")].size} files — all have assembler source + precept: + ## Corollaries"
  puts "SPEC:    #{Dir[EntityGlob.call("specifications")].size} files — all have specifies: field, no principle:/precept:"
else
  puts "❌  #{violations.size} violation(s)"
  puts
  by_type = violations.group_by { |r| r[2] }
  by_type.sort.each do |code, group|
    puts "  #{code} (#{group.size}):"
    group.each do |id, type, code, msg|
      puts "    #{id} (#{type}) — #{msg}"
    end
    puts
  end
end
