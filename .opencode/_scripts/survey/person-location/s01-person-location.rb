#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — scan .opencode/ for outdated person directory path references
# survey: person-location
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"

OPCODE = ROOT.join(".opencode")
SKIP_DIRS = %w[reports _backups]

CORRECT_PATH = ".opencode/entities/persons/"
WRONG_PATHS = [
  ".opencode/persons/",
]

wrong_hits = []
correct_count = 0
ambiguous_bare_hits = []

Dir[OPCODE.join("**", "*.md")].sort.each do |path|
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  next if SKIP_DIRS.any? { |d| rel.start_with?(".opencode/#{d}") }

  text = File.read(path)
  lines = text.split("\n")

  lines.each_with_index do |line, idx|
    lineno = idx + 1

    # Check for known wrong qualified paths
    WRONG_PATHS.each do |wp|
      if line.include?(wp)
        wrong_hits << [rel, lineno.to_s, wp, line.strip]
      end
    end

    # Count correct path references
    if line.include?(CORRECT_PATH)
      correct_count += 1
    end

    # Check for bare `persons/` (unqualified — ambiguous)
    if line.match?(%r{(?<!\.opencode/entities/)persons/}) && !line.include?(CORRECT_PATH) && !line.include?("persons.db")
      # Only flag if it looks like a directory reference, not a DB table or SQL
      if line.match?(%r{["'`]?persons/}) && !line.include?("00-persons.sql")
        ambiguous_bare_hits << [rel, lineno.to_s, "persons/", line.strip] unless WRONG_PATHS.any? { |wp| line.include?(wp) }
      end
    end
  end
end

puts "=== Person Location Path Audit ==="
puts ""

if wrong_hits.empty? && ambiguous_bare_hits.empty?
  puts "No outdated person path references found."
else
  unless wrong_hits.empty?
    puts "Wrong qualified paths (`.opencode/persons/`):"
    puts Table.call(wrong_hits, %w[File Line Path Context])
    puts ""
  end

  unless ambiguous_bare_hits.empty?
    puts "Ambiguous bare `persons/` references (no `.opencode/entities/` prefix):"
    puts Table.call(ambiguous_bare_hits, %w[File Line Path Context])
    puts ""
  end
end

puts "Correct path references (`#{CORRECT_PATH}`): #{correct_count}"
puts "Outdated qualified path references: #{wrong_hits.size}"
puts "Ambiguous bare `persons/` references: #{ambiguous_bare_hits.size}"
