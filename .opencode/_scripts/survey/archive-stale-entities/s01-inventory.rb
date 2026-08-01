#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — inventory of stale entity files for archiving
# survey: archive-stale-entities

require_relative "../../_rb/loader"
require_relative "../../_rb/report"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath

ARCHIVE_DIR = ROOT.join("_scripts", "archive")

CANDIDATES = [
  {
    id: "PROT.META.ENTITY.DISTINCTION",
    path: ROOT.join(".opencode", "entities", "protocols", "PROT.META.ENTITY.DISTINCTION.md"),
    archive: ARCHIVE_DIR.join("PROT.META.ENTITY.DISTINCTION.md"),
    type: "protocol",
    superseded_by: "SPEC.META.ENTITY.DISTINCTION",
    reason: "Content boundary rules moved to specification entity type"
  },
  {
    id: "pattern-vs-term",
    path: ROOT.join(".opencode", "rules", "pattern-vs-term.md"),
    archive: ARCHIVE_DIR.join("pattern-vs-term.md"),
    type: "rule",
    superseded_by: "SPEC.META.ENTITY.DISTINCTION",
    reason: "Superseded by specification entity type classification"
  },
  {
    id: "pattern-vs-term.yaml",
    path: ROOT.join(".opencode", "rules", "yamls", "pattern-vs-term.yaml"),
    archive: ARCHIVE_DIR.join("pattern-vs-term.yaml"),
    type: "rule-yaml",
    superseded_by: "SPEC.META.ENTITY.DISTINCTION",
    reason: "YAML registry for stale rule"
  },
  {
    id: "PROT.CONTENT.GLOSSARY",
    path: ROOT.join(".opencode", "entities", "archives", "PROT.CONTENT.GLOSSARY.md"),
    archive: ARCHIVE_DIR.join("PROT.CONTENT.GLOSSARY.md"),
    type: "protocol",
    superseded_by: nil,
    reason: "Stale archive entity — entity type unused, no GLOSS.* files exist"
  },
  {
    id: "PROT.META.CATEGORY.VIEW",
    path: ROOT.join(".opencode", "entities", "archives", "PROT.META.CATEGORY.VIEW.md"),
    archive: ARCHIVE_DIR.join("PROT.META.CATEGORY.VIEW.md"),
    type: "protocol",
    superseded_by: nil,
    reason: "Stale archive entity — intellectual model, not actionable"
  }
]

puts "=== Archive Stale Entities — Inventory ==="
puts

rows = CANDIDATES.map do |c|
  exists = c[:path].exist? ? "YES" : "NO"
  spec = c[:superseded_by]
  spec_exists = spec ? ROOT.join(".opencode", "entities", "specifications", "#{spec}.md").exist? : false
  superseder = if spec
    spec_exists ? "#{spec} (EXISTS)" : "#{spec} (MISSING)"
  else
    "(none)"
  end
  [c[:id], c[:type], exists, superseder, c[:reason]]
end

puts Table.call(rows, %w[ID Type Exists Superseder Reason])
puts

existing = CANDIDATES.count { |c| c[:path].exist? }
puts "Total candidates: #{CANDIDATES.size}"
puts "Files exist: #{existing}"
puts "Archive destination: #{ARCHIVE_DIR}"
puts

puts "=== Archive status ==="
puts
Dir.glob(ARCHIVE_DIR.join("*.md")).each do |p|
  puts "  #{Pathname.new(p).basename}"
end
puts

puts "=== Action summary ==="
puts
CANDIDATES.each do |c|
  status = if c[:path].exist?
    "mv #{c[:path].relative_path_from(ROOT)} → #{c[:archive].relative_path_from(ROOT)}"
  else
    "NOT FOUND — #{c[:path].relative_path_from(ROOT)}"
  end
  puts "  #{status}"
end
