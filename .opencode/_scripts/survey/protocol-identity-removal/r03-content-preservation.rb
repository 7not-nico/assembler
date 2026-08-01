#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — check each PROT.*.IDENTITY for protocol content worth preserving
# survey: protocol-identity-removal

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

Dir[EntityGlob.call("protocols")].each do |path|
  base = File.basename(path, ".md")
  next unless base.match?(/\.IDENTITY$/)

  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  target = "IDENTITY." + base.sub(/^PROT\./, "").sub(/\.IDENTITY$/, "")

  body = text.sub(/\A---\s*\n.*?\n---\s*\n/m, "").strip

  # Content worth preserving — not identity, but technical contract
  has_schema = body.include?("## Protocol") || body.include?("### Schema")
  has_gotchas = body.include?("## Gotchas")
  has_enforcement = body.include?("## Enforcement")
  has_applicability = body.include?("## Applicability")

  # Protocol field content — the technical contract
  protocol_field = fm[:protocol].to_s
  has_contract = protocol_field.length > 10

  preserving = []
  preserving << "Schema" if has_schema
  preserving << "Gotchas" if has_gotchas
  preserving << "Enforcement" if has_enforcement
  preserving << "Applicability" if has_applicability
  preserving << "protocol field" if has_contract

  puts "#{base}"
  puts "  → #{target}"
  puts "  Protocol content to preserve: #{preserving.empty? ? 'none (pure identity)' : preserving.join(', ')}"
  puts "  Suggested action: #{preserving.empty? ? 'DELETE entirely' : "STRIP identity content, RENAME to #{target.sub('IDENTITY.', 'PROT.').sub(/.IDENTITY$/, '')}"}"
  puts
end
