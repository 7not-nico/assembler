#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — generate proposed IDENTITY.* content from each PROT.*.IDENTITY
# survey: identities-extraction

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

IDENTITY_TARGET = {
  "PROT.COGNITION.IDENTITY" => {
    target: "IDENTITY.COGNITION",
    first_line: "**Cognition** — a domain of knowing, the first layer of the Encyclopedic group.",
    second_line: "Cognitions answer *what domain*. They define broad fields of study that serve as the top-layer foundation for all other Encyclopedic entity types.",
  },
  "PROT.CONCEPT.IDENTITY" => {
    target: "IDENTITY.CONCEPT",
    first_line: "**Concept** — a non-physical idea, the second layer of the Encyclopedic group.",
    second_line: "Concepts answer *what idea*. They sit between cognitions (domain) and definitions (physical things).",
  },
  "PROT.DEFINITION.IDENTITY" => {
    target: "IDENTITY.DEFINITION",
    first_line: "**Definition** — a physical thing, the second layer of the Encyclopedic group.",
    second_line: "Definitions answer *what thing*. They describe tangible entities that have a physical referent.",
  },
  "PROT.ILLUSTRATION.IDENTITY" => {
    target: "IDENTITY.ILLUSTRATION",
    first_line: "**Illustration** — a walkthrough of a single instance of a pattern or protocol.",
    second_line: "Illustrations trace through concrete examples, step by step. They target patterns (morphisms) and nexi (compositions) only.",
  },
  "PROT.MAXIM.IDENTITY" => {
    target: "IDENTITY.MAXIM",
    first_line: "**Maxim** — an aphoristic principle entity encoding a universal design truth.",
    second_line: "Maxims are orthogonal — no precedes between maxims. They use line-junction notation for categorization.",
  },
  "PROT.META.PROTOCOL.IDENTITY" => {
    target: "IDENTITY.META.PROTOCOL",
    first_line: "**Entity Identity** — the metadata and body protocol for every entity type.",
    second_line: "Every entity identity protocol documents two categories: metadata (frontmatter fields) and body (content sections).",
  },
  "PROT.RULE.IDENTITY" => {
    target: "IDENTITY.RULE",
    first_line: "**Rule** — an entity of the Architectonic group, Ring 2, governing commands and skills.",
    second_line: "Rules are session-level instructions that compose with other rules. Each rule YAML has id, title, group, tags, and optionally related and category.",
  },
  "PROT.SKILL.IDENTITY" => {
    target: "IDENTITY.SKILL",
    first_line: "**Skill** — a procedure provider following {action}-{domain} naming.",
    second_line: "Skills are hybrid state automata. Each skill in .opencode/skills/ uses {action}-{domain} naming with a SKILL.md format.",
  },
  "PROT.TAX.IDENTITY" => {
    target: "IDENTITY.TAX",
    first_line: "**Taxonomy** — a biological classification rank at Ring 2 of the Encyclopedic group.",
    second_line: "Taxonomies answer *what kind*. Each taxon sources to its parent taxon (same ring) or a cognition (inner ring) when the chain ends.",
  },
  "PROT.TERM.IDENTITY" => {
    target: "IDENTITY.TERM",
    first_line: "**Term** — a vocabulary entry that defines a project label.",
    second_line: "Terms answer *what label*. Internal terms source from assembler; external terms source from a CON.* or DEF.* ID.",
  },
}

rows = []

Dir[EntityGlob.call("protocols")].each do |path|
  base = File.basename(path, ".md")
  next unless IDENTITY_TARGET.key?(base)

  info = IDENTITY_TARGET[base]
  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  original_tags = fm[:tags]
  tags = original_tags.is_a?(Array) ? original_tags.join(",") : original_tags.to_s
  tags = (tags.split(",") + ["identity"]).uniq.join(",")

  rows << [
    base,
    info[:target],
    info[:first_line],
    info[:second_line],
    fm[:source].to_s,
    tags,
  ]
end

puts "=== Proposed IDENTITY.* Files ==="
puts
puts Table.call(rows, %w[Source Target Line1 Line2 Source Tags])
puts
puts "#{rows.size} identity files to create in entities/identities/"
puts
puts "Format: backmatter (body + --- YAML)"
puts "Fields: id, title, source, tags, related, reference"
puts "Body: **{Name}** — {line1}. {line2}"
puts "source: points to originating PROT.*.IDENTITY"
