#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — validate Rust identifiers use concrete nouns, not abstract generics
# survey: rust-code-survey
# scans _rustlib/src/*.rs, extracts function/type/variable names, flags abstract generics

require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..", ".opencode", "_rustlib", "src").expand_path
SEPARATOR = "─" * 72

# Abstract/generic nouns that fail the "concrete noun" requirement
# These are too generic — they don't describe WHAT the thing IS.
ABSTRACT_NOUNS = %w[
  data info value item thing object
  handler manager processor controller
  util helper common misc
  stuff input output temp tmp
  args params opts config
  entry record row col
  element node entity thingy
  wrapper adapter bridge
  factory provider resolver
  context environment state
  result outcome response
  request query command
  event signal message
  container holder bucket
  setter getter accessor
].freeze

# Patterns that match concrete noun identifiers
# Concrete nouns: specific domain terms that describe WHAT the thing IS
# e.g.: Frontmatter (not Data), EntityEntry (not Item), patlib_id (not id)
CONCRETE_PATTERNS = [
  /\A[A-Z][a-z]+/,           # PascalCase type: Frontmatter, RingInfo
  /\A[A-Z][A-Z]+(?:_[A-Z]+)*\z/, # SCREAMING_SNAKE: BURST_THRESHOLD
  /\A[a-z][a-z0-9]*(?:_[a-z0-9]+)*\z/,  # snake_case: parse_frontmatter
  /\A[A-Z][a-z]+(?:_[A-Z][a-z]+)*\z/,   # Upper_Snake: FileEvent
].freeze

# Special allowed identifiers (not concrete nouns but acceptable conventions)
ALLOWED_SPECIAL = %w[
  new default open init
  id r#type
  is_some is_none is_empty
  as_str as_ref clone
  from_str to_string
  len capacity contains
  iter into_iter
  ok err unwrap expect
  map filter fold reduce
  push pop insert remove
  sort reverse truncate
  split join concat
  find search match
  eq cmp hash
  debug display
].freeze

ScanRustFiles = ->(dir) {
  Dir[dir.join("*.rs")].sort
}

# Pure: extract Rust identifiers (pub fn, pub struct, pub enum, pub const, pub static, let, fn parameters)
ExtractIdentifiers = ->(text) {
  ids = []

  # Public function names
  text.scan(/pub\s+fn\s+(\w+)/) { ids << [$1, "function"] }
  # Private function names
  text.scan(/^\s*fn\s+(\w+)/) { ids << [$1, "function"] }
  # Public struct names
  text.scan(/pub\s+struct\s+(\w+)/) { ids << [$1, "struct"] }
  # Public enum names
  text.scan(/pub\s+enum\s+(\w+)/) { ids << [$1, "enum"] }
  # Public const/static
  text.scan(/pub\s+(?:const|static)\s+(\w+)/) { ids << [$1, "constant"] }
  # Module names in mod declarations
  text.scan(/(?:pub\s+)?mod\s+(\w+)/) { ids << [$1, "module"] }
  # Type aliases
  text.scan(/pub\s+type\s+(\w+)/) { ids << [$1, "type"] }
  # Trait names
  text.scan(/pub\s+trait\s+(\w+)/) { ids << [$1, "trait"] }

  ids.uniq
}

# Pure: check if an identifier uses a concrete noun
AbstractDetected = ->(name) {
  down = name.downcase.gsub(/[^a-z0-9]/, "")
  ABSTRACT_NOUNS.each do |abstract|
    # Check if the abstract noun appears as a standalone word in the identifier
    if down == abstract || down.start_with?("#{abstract}_") || down.end_with?("_#{abstract}") || down.include?("_#{abstract}_")
      return abstract
    end
  end
  nil
}

# Pure: classify identifier kind
IdKind = ->(name) {
  return :screaming_snake if name.match?(/\A[A-Z][A-Z]+(?:_[A-Z]+)*\z/)
  return :pascal if name.match?(/\A[A-Z][a-z]/)
  return :snake if name.match?(/\A[a-z][a-z0-9]*(?:_[a-z0-9]+)*\z/)
  return :upper_snake if name.match?(/\A[A-Z][a-z]+(?:_[A-Z][a-z]+)*\z/)
  :other
}

# --- Main ---

violations = []
stats = Hash.new(0)

ScanRustFiles.call(ROOT).each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT.parent).to_s
  text = File.read(path)
  identifiers = ExtractIdentifiers.call(text)

  identifiers.each do |name, kind|
    stats[kind] += 1

    # Skip allowed special names
    next if ALLOWED_SPECIAL.include?(name) || ALLOWED_SPECIAL.include?(name.sub(/^r#/, ""))

    # Check for abstract nouns
    abstract = AbstractDetected.call(name)
    if abstract
      violations << { file: rel, name: name, type: kind, problem: "abstract noun '#{abstract}'", line: find_line(text, name) }
    end
  end
end

def find_line(text, name)
  text.lines.each_with_index { |line, i| return i + 1 if line.include?(name) }
  0
end

puts "#{SEPARATOR}"
puts "Rust Concrete Noun Survey"
puts "  Source: #{ROOT}"
puts "  Abstract noun blocklist: #{ABSTRACT_NOUNS.join(", ")}"
puts "#{SEPARATOR}"
puts

if violations.empty?
  puts "ok — 0 violations, #{stats.values.sum} identifiers checked"
else
  puts "Violations (#{violations.size}):"
  puts
  violations.each do |v|
    puts "  #{v[:file]}:#{v[:line]}  #{v[:type].ljust(10)} #{v[:name].ljust(30)} #{v[:problem]}"
  end
  puts
end

puts "#{SEPARATOR}"
puts "Identifier counts by kind:"
stats.sort_by { |_, v| -v }.each { |k, v| puts "  #{k.to_s.ljust(12)} #{v}" }
puts
puts "Total identifiers checked: #{stats.values.sum}"
puts "#{SEPARATOR}"
