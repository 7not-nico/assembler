#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — output draft structure for PROT.ML.IDENTITY.SCHEMA.md
# survey: ml-entity-type — combine s01 + s02 findings into protocol draft

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

puts "=== PROT.ML.IDENTITY.SCHEMA — Draft Structure ==="
puts ""
puts "Protocol frontmatter:"
puts ""

fm = [
  ["id", "PROT.ML.IDENTITY.SCHEMA"],
  ["title", "ML Identity — Machine Learning Entity Protocol"],
  ["source", "NEX.META.ENTITY.PROPOSAL"],
  ["summary", '"Defines the ml/ directory and ML.* entity type — schema, body convention, enforcement, and relationship to other entity types."'],
  ["protocol", '"An ML entity defines a machine learning algorithm, architecture, or technique — Encyclopedic Ring 3. Location: ml/ML.*.md with ML.* ID prefix. source points to a CON.* or COG.* entity (inner ring). related connects to other ML.* entities horizontally."'],
  ["enforcement", "Tool"],
  ["tags", "[ml, machine-learning, entity-type, algorithm, architecture, technique]"],
  ["status", "active"],
  ["priority", "2"],
]

puts Table.call(fm, %w[Field Value])

puts ""
puts "Schema table:"
puts ""

schema = [
  ["id", "Yes", "ML.{NAME} uppercase dot-separated"],
  ["title", "Yes", "Human-readable name"],
  ["source", "Yes", "CON.* or COG.* ID — the concept or cognition this ML entity belongs to"],
  ["precedes", "No", "Entity ID array — other ML.* IDs this technique builds on"],
  ["type", "Yes", "Kind: architecture, algorithm, method, task, metric, paradigm"],
  ["paradigm", "Yes", "Learning paradigm: supervised, unsupervised, reinforcement, self-supervised, semi-supervised"],
  ["subfield", "Yes", "ML subfield(s): deep-learning, ensemble-methods, probabilistic-ml, optimization, ..."],
  ["category", "Yes", "Technique category: sparse-computation, gating, attention, regularization, representation-learning, ..."],
  ["tags", "Yes", "Comma-separated, no spaces"],
  ["related", "No", "Entity ID array — other ML.* IDs only (horizontal layer)"],
  ["reference", "Yes", "Array of {title, url}; minimum 3"],
]

puts Table.call(schema, %w[Field Required Format])

puts ""
puts "Body convention:"
puts "  First line: **{Title}** — {1-3 sentence description}. Optional subsections follow."
puts ""
puts "Content rules:"
puts "  - type: required — one of architecture, algorithm, method, task, metric, paradigm"
puts "  - paradigm: required — the learning paradigm(s)"
puts "  - subfield: required — ML subfield(s) the entity belongs to"
puts "  - category: required — technique category for classification"
puts "  - Tags: comma-separated — spaces excluded"
puts "  - References: minimum 3 authoritative sources with URL+title"
puts "  - Related: limited to other ML.* IDs — horizontal layer only"
puts "  - source: valid CON.* or COG.* ID — vector points to containing concept/cognition"
puts "  - Sync: name-to-name into ml table — DB cache, file is source of truth"
puts ""
puts "Application to ML.MIXTUREOFEXPERTS:"
puts ""
moe = [
  ["id", "ML.MIXTUREOFEXPERTS"],
  ["title", "Mixture of Experts"],
  ["type", "architecture"],
  ["paradigm", "supervised"],
  ["subfield", "deep-learning, ensemble-methods"],
  ["category", "sparse-computation, gating"],
  ["source", "CON.MACHINE.LEARNING"],
  ["precedes", "[]"],
  ["tags", "mixture-of-experts, moe, sparse-activation, gating-network, conditional-computation, neural-network, llm"],
  ["related", "[]"],
]
puts Table.call(moe, %w[Field Value])
