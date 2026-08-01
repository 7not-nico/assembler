#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify each IDENTITY.* captures naming, definition, and ring placement
# survey: identities-audit

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/patlib"
require_relative "../../_rb/rings"
require_relative "../../_rb/report"

REQUIRED_SECTIONS = {
  "IDENTITY.COGNITION"     => { prefix: "COG.",  dir: "cognitions" },
  "IDENTITY.CONCEPT"       => { prefix: "CON.",  dir: "concepts" },
  "IDENTITY.DEFINITION"    => { prefix: "DEF.",  dir: "definitions" },
  "IDENTITY.ILLUSTRATION"  => { prefix: "ILL.",  dir: "illustrations" },
  "IDENTITY.KNOWLEDGE"     => { prefix: nil,     dir: "knowledge" },
  "IDENTITY.MAXIM"         => { prefix: "MAX.",  dir: "maxims" },
  "IDENTITY.META.PROTOCOL" => { prefix: "PROT.", dir: "protocols" },
  "IDENTITY.RULE"          => { prefix: "RUL.",  dir: "rules" },
  "IDENTITY.SKILL"         => { prefix: nil,     dir: "skills" },
  "IDENTITY.SURVEY"        => { prefix: nil,     dir: "survey" },
  "IDENTITY.TAX"           => { prefix: "TAX.",  dir: "taxonomy" },
  "IDENTITY.TERM"          => { prefix: "TERM.", dir: "terms" },
}

violations = []

Dir[EntityGlob.call("identities")].sort.each do |path|
  base = File.basename(path, ".md")
  spec = REQUIRED_SECTIONS[base]
  next unless spec  # skip unknown identities

  text = File.read(path)
  meta = ParseBackmatter.call(text)

  unless meta
    violations << [base, "metadata", "no parseable backmatter"]
    next
  end

  body = text.sub(/---\s*\n.*?\n---\s*\z/m, "").strip

  # Check 1: Body has "what it IS" — starts with **{Name}** — {description}
  unless body.match?(/\A\*\*[^*]+\*\*\s*—/)
    violations << [base, "body", "missing **{Name}** — {description} opening"]
  end

  # Check 2: Body has naming convention section
  unless body.match?(/\*\*Naming:\*\*/)
    violations << [base, "body", "missing **Naming:** section"]
  end

  # Check 3: Body has part-of section
  unless body.match?(/\*\*Part of:\*\*/)
    violations << [base, "body", "missing **Part of:** section"]
  end

  # Check 4: Backmatter source points to a valid entity
  src = meta[:source].to_s
  unless src.empty?
    src_type = IdToType.call(src)
    unless src_type
      violations << [base, "source", "source #{src} does not match any entity prefix"]
    end
  end

  # Check 5: Tags include "identity"
  tg = meta[:tags]
  tags = tg.is_a?(Array) ? tg : tg.to_s.split(",").map(&:strip)
  unless tags.include?("identity")
    violations << [base, "tags", "missing 'identity' tag"]
  end
end

puts "=== Identities Audit ==="
puts
if violations.empty?
  puts "ok — #{Dir[EntityGlob.call("identities")].size} identities, 0 violations"
else
  puts "violations (#{violations.size}):"
  puts Table.call(violations, %w[Identity Field Problem])
end
