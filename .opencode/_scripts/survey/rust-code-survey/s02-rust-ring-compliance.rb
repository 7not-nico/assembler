#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — validate Rust code ring compliance per SPEC.CODE.RING.TOPOLOGY
# survey: rust-code-survey
# checks every .rs file in _rustlib/ for:
#   1. ring header matches filename r{N} prefix
#   2. Ring 0 files contain no I/O operations
#   3. Cross-ring dependencies don't violate ring rules

require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..", ".opencode", "_rustlib", "src").expand_path
SEPARATOR = "─" * 72

# IO-related patterns that belong to Ring 1+ only
IO_PATTERNS = [
  /\bstd::fs\b/, /\bstd::io\b/, /\bstd::net\b/, /\bstd::process\b/,
  /\bstd::env\b/, /\bFile::/, /\bOpenOptions\b/, /\bread_to_string\b/,
  /\bread_dir\b/, /\bWalkDir\b/, /\bmetadata\b/, /\bstd::os\b/,
  /\bfs::/, /\bio::/,
  /\bBun\b/, /\bspawn\b/, /\bexec\b/, /\bProcess\b/,
  /\brusqlite\b/, /\bConnection\b/, /\bDatabase\b/,
].freeze

# Cross-ring dependency rules:
# Ring N may depend on Ring M only if M <= N (inner rings are visible to outer)
RING_ORDER = { 0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6 }

ScanRustFiles = ->(dir) {
  Dir[dir.join("*.rs")].sort
}

# Extract the ring number from filename r{N}*
def ring_from_filename(filename)
  m = filename.match(/\Ar(\d+)/)
  m ? m[1].to_i : nil
end

# Extract the ring number from // ring: N header
def ring_from_header(text)
  m = text.match(%r{//\s*ring:\s*(\d+)})
  m ? m[1].to_i : nil
end

# Extract use statements for cross-module dependency analysis
def extract_use_crate(text)
  text.scan(/use\s+crate::(\w+)/).flatten.uniq
end

# Extract use of std::* IO modules
def extract_io_uses(text)
  uses = []
  text.scan(/use\s+(std::\w+(?:::?\w+)*)/).flatten.each do |u|
    IO_PATTERNS.each { |pat| uses << u if u.match?(pat) }
  end
  uses.uniq
end

# --- Main ---

violations = []
stats = { files: 0, ring0: 0, ring1: 0, ring2: 0, unknown: 0 }

ScanRustFiles.call(ROOT).each do |path|
  rel = File.basename(path, ".rs")
  next if %w[lib main].include?(rel) # lib.rs and main.rs are entry points, not ring-classified
  stats[:files] += 1

  text = File.read(path)
  file_ring = ring_from_filename(rel)
  header_ring = ring_from_header(text)

  # 1. Check filename prefix matches header
  if file_ring.nil?
    violations << { file: rel, problem: "filename missing r{N} prefix" }
    next
  end

  if header_ring.nil?
    violations << { file: rel, problem: "missing // ring: N header" }
    next
  end

  if file_ring != header_ring
    violations << { file: rel, problem: "filename says r#{file_ring}, header says r#{header_ring}" }
  end

  ring_key = file_ring <= 0 ? :ring0 : (file_ring <= 1 ? :ring1 : :ring2)
  stats[ring_key] += 1

  # 2. Ring 0 check: no I/O operations
  if file_ring == 0
    io_uses = extract_io_uses(text)
    if io_uses.any?
      violations << { file: rel, problem: "Ring 0 has I/O imports: #{io_uses.join(", ")}" }
    end

    # Check for IO patterns in function bodies (excluding test modules)
    body = text.gsub(/#\[cfg\(test\)\].*?\z/m, "")
    IO_PATTERNS.each do |pat|
      if body.match?(pat)
        # Check if the match is inside a comment
        body.lines.each_with_index do |line, i|
          if line.match?(pat) && !line.strip.start_with?("//", "///", "#[", "//!")
            violations << { file: rel, problem: "Ring 0 has IO operation '#{pat.source}' at line #{i + 1}" }
          end
        end
      end
    end
  end

  # 3. Check cross-ring crate dependencies
  deps = extract_use_crate(text)
  deps.each do |dep|
    # Find the ring of the dependency by scanning other files
    dep_file = rel.gsub(/\Ar\d+_/, "")
    dep_ring = nil
    ScanRustFiles.call(ROOT).each do |dp|
      db = dp.basename(".rs").to_s
      if db.end_with?(dep) || db == "#{dep}.rs" || db.match?(/\Ar\d+_#{dep}\z/)
        dr = ring_from_filename(db)
        dep_ring = dr if dr
      end
    end
    if dep_ring && dep_ring > file_ring
      violations << { file: rel, problem: "r#{file_ring} imports r#{dep_ring} module '#{dep}' — outer ring cannot depend on inner" }
    end
  end
end

puts "#{SEPARATOR}"
puts "Rust Ring Compliance Survey"
puts "  Source: #{ROOT}"
puts "#{SEPARATOR}"
puts

if violations.empty?
  puts "ok — 0 violations across #{stats[:files]} files"
else
  puts "Violations (#{violations.size}):"
  puts
  violations.each do |v|
    puts "  #{v[:file].ljust(35)} #{v[:problem]}"
  end
  puts
end

puts "#{SEPARATOR}"
puts "Ring distribution:"
puts "  Ring 0 (PURE):       #{stats[:ring0]}"
puts "  Ring 1 (DB-READ):    #{stats[:ring1]}"
puts "  Ring 2 (LOCAL-READ): #{stats[:ring2]}"
puts "  Unknown:             #{stats[:unknown]}"
puts "  Total:               #{stats[:files]}"
puts "#{SEPARATOR}"
