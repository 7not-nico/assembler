#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — analyze ML-related entities, propose ML entity fields
# survey: ml-entity-type — derive domain-specific ML metadata fields

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

# 1. Read ML-related entities
targets = {
  "COG.MACHINE.LEARNING" => ENTITIES.join("cognitions", "COG.MACHINE.LEARNING.md"),
  "CON.MACHINE.LEARNING" => ENTITIES.join("concepts", "CON.MACHINE.LEARNING.md"),
  "TERM.GPT" => ENTITIES.join("terms", "TERM.GPT.md"),
  "TERM.BERT" => ENTITIES.join("terms", "TERM.BERT.md"),
}

puts "=== Existing ML-Related Entities — Metadata Survey ==="
puts ""

targets.each do |id, file|
  if File.exist?(file)
    text = File.read(file)
    bak = ParseBackmatter.call(text)
    if bak
      body = text.split(/---/).first.strip
      puts "── #{id} ──────────────────────────────"
      puts "  Body: #{body[0..120]}..."
      bak.each { |k, v| puts "  #{k}: #{v.is_a?(Array) ? v.join(", ") : v}" }
      puts ""
    end
  else
    puts "── #{id} — NOT FOUND"
    puts ""
  end
end

# 2. Compare metadata patterns
puts "=== Metadata Pattern Analysis ==="
puts ""

# Extract fields across entity types
type_fields = {}
targets.each do |id, file|
  next unless File.exist?(file)
  text = File.read(file)
  bak = ParseBackmatter.call(text)
  next unless bak
  prefix = id.split(".").first
  type_fields[prefix] ||= {}
  bak.each { |k, v| type_fields[prefix][k] = true }
end

puts "Field presence by prefix:"
puts ""
type_fields.each do |prefix, fields|
  puts "  #{prefix}: #{fields.keys.sort.join(", ")}"
end

# 3. Propose ML entity fields
puts ""
puts "=== Proposed ML Entity Schema Fields ==="
puts ""
puts "Each ML entity (ML.*) describes a machine learning algorithm, architecture, or technique."
puts ""
puts "Proposed fields based on analysis:"
puts ""

proposal = [
  ["id", "Yes", "ML.{NAME} uppercase dot-separated"],
  ["title", "Yes", "Human-readable name"],
  ["source", "Yes", "CON.* or COG.* ID"],
  ["precedes", "No", "Entity ID array — technique lineage"],
  ["type", "Yes", "\"architecture\", \"algorithm\", \"method\", \"task\", \"metric\", \"paradigm\""],
  ["paradigm", "Yes", "\"supervised\", \"unsupervised\", \"reinforcement\", \"self-supervised\", \"semi-supervised\""],
  ["subfield", "Yes", "ML subfield(s): deep-learning, ensemble-methods, probabilistic-ml, optimization, ..."],
  ["category", "Yes", "Technique category: sparse-computation, gating, attention, regularization, representation-learning, ..."],
  ["tags", "Yes", "Comma-separated, no spaces"],
  ["related", "No", "Entity ID array — other ML.* IDs"],
  ["reference", "Yes", "Array of {title, url}; minimum 3"],
]

puts Table.call(proposal, %w[Field Required Format])
