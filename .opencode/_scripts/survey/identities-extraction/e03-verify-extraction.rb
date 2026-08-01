#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify no content loss when extracting IDENTITY.* from PROT.*.IDENTITY
# survey: identities-extraction

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

PAIRS = {
  "PROT.COGNITION.IDENTITY" => "IDENTITY.COGNITION",
  "PROT.CONCEPT.IDENTITY" => "IDENTITY.CONCEPT",
  "PROT.DEFINITION.IDENTITY" => "IDENTITY.DEFINITION",
  "PROT.ILLUSTRATION.IDENTITY" => "IDENTITY.ILLUSTRATION",
  "PROT.MAXIM.IDENTITY" => "IDENTITY.MAXIM",
  "PROT.META.PROTOCOL.IDENTITY" => "IDENTITY.META.PROTOCOL",
  "PROT.RULE.IDENTITY" => "IDENTITY.RULE",
  "PROT.SKILL.IDENTITY" => "IDENTITY.SKILL",
  "PROT.TAX.IDENTITY" => "IDENTITY.TAX",
  "PROT.TERM.IDENTITY" => "IDENTITY.TERM",
}

warnings = []

Dir[EntityGlob.call("protocols")].each do |path|
  base = File.basename(path, ".md")
  next unless PAIRS.key?(base)

  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  target_id = PAIRS[base]
  target_path = Dir[EntityGlob.call("identities")].find { |p|
    File.basename(p, ".md") == target_id
  }

  unless target_path
    warnings << [target_id, base, "NOT YET CREATED", "IDENTITY file missing — extraction not applied"]
    next
  end

  target_text = File.read(target_path)
  target_meta = ParseBackmatter.call(target_text)
  unless target_meta
    warnings << [target_id, base, "UNPARSEABLE", "backmatter parse failed — fix syntax"]
    next
  end

  target_body = target_text.sub(/---\s*\n.*?\n---\s*\z/m, "").strip

  # Check 1: source points back to protocol
  unless target_meta[:source].to_s == base
    warnings << [target_id, base, "SOURCE MISMATCH", "source=#{target_meta[:source]} expected=#{base}"]
  end

  # Check 2: identity tags include "identity"
  tg = target_meta[:tags]
  tags = tg.is_a?(Array) ? tg : tg.to_s.split(",").map(&:strip)
  unless tags.include?("identity")
    warnings << [target_id, base, "TAGS MISSING identity", "add 'identity' to tags"]
  end

  # Check 3: body is non-empty
  if target_body.empty?
    warnings << [target_id, base, "BODY EMPTY", "identity body cannot be empty"]
  end

  # Check 4: body starts with **{Name}**
  unless target_body.start_with?("**")
    warnings << [target_id, base, "BODY FORMAT", "body must start with **{Name}** — {description}"]
  end

  # Check 5: protocol fields not lost — verify summary appears in extracted identity context
  summary = fm[:summary].to_s
  protocol = fm[:protocol].to_s
  if summary.length > 5 && !target_body.include?(summary[0..40])
    warnings << [target_id, base, "SUMMARY NOT PRESERVED", "summary text not found in identity body"]
  end
end

puts "=== Extraction Integrity Check ==="
puts
if warnings.empty?
  puts "All #{PAIRS.size} pairs verified — no issues."
else
  puts Table.call(warnings, %w[Target Source Type Detail])
  puts
  puts "#{warnings.size} warnings"
end
