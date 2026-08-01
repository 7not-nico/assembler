#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — validate person naming and file location compliance
# survey: person-identity
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"
require "set"

PERSONS_DIR = ENTITIES.join("persons")

def expected_filename(id)
  id.downcase.tr(".", "-") + ".md"
end

violations = []
ok_count = 0

Dir[EntityGlob.call("persons")].sort.each do |path|
  text = File.read(path)
  fm = ParseFrontmatter.call(text)
  next unless fm

  id = fm[:id].to_s
  basename = File.basename(path)
  expected = expected_filename(id)

  # Check 1: File name matches expected kebab-case
  unless basename == expected
    violations << [id, "filename", basename, "expected #{expected}"]
  end

  # Check 2: File location is under .opencode/entities/persons/
  dir = File.dirname(path)
  unless dir == PERSONS_DIR.to_s
    violations << [id, "location", dir, "expected #{PERSONS_DIR}"]
  end

  # Check 3: ID matches PER.{NAMESPACE}.{NAME} pattern
  unless id.match?(/\APER\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*\z/)
    violations << [id, "id-format", id, "does not match PER.{NAMESPACE}.{NAME}"]
  end

  # Check 4: Last segment of ID matches file name in kebab-case
  id_lower = id.downcase
  name_from_id_basename = expected.sub(/\.md\z/, "")
  file_basename_noext = basename.sub(/\.md\z/, "")
  unless file_basename_noext == name_from_id_basename
    violations << [id, "segment-mismatch", basename, "last segment of id '#{id_lower}' does not match"]
  end

  ok_count += 1
end

puts "=== Person Naming Compliance ==="
puts ""

if violations.empty?
  puts "ok — #{ok_count} persons, 0 naming violations"
else
  puts "violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Check File Expected])
end

puts ""

# Also cross-reference DB: persons in DB but no file on disk
db_path = ROOT.join("patlib.db")
if File.exist?(db_path)
  db_persons = `sqlite3 #{db_path} "SELECT id FROM persons ORDER BY id" 2>/dev/null`.strip.lines.map(&:strip)
  file_persons = Dir[EntityGlob.call("persons")].filter_map { |p|
    ParseFrontmatter.call(File.read(p))&.dig(:id).to_s
  }
  file_set = file_persons.to_set

  missing_files = db_persons.reject { |pid| file_set.include?(pid) }
  unless missing_files.empty?
    puts "Persons in DB with no file on disk:"
    missing_files.each { |id| puts "  #{id}" }
  else
    puts "DB/filesystem match: all #{db_persons.size} DB entries have corresponding files"
  end
end
