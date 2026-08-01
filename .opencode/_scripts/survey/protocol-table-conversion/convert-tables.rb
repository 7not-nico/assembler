#!/usr/bin/env ruby
# ring: 1 (LOCAL-WRITE) — batch convert gotchas/antipattern tables to bullet lists in protocols
# survey: protocol-table-conversion
# writes: modifies protocol files

require_relative "../../_rb/loader"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
PROTOCOLS = ROOT.join(".opencode", "entities", "protocols")

def is_gotchas_table?(lines, table_start)
  # Check if table headers indicate a gotchas/antipattern table
  header = lines[table_start].to_s.strip.downcase
  header.include?("signal") && header.include?("detection") && header.include?("redirect") ||
  header.include?("antipattern") && header.include?("detection") && header.include?("redirect")
end

def convert_table_row(line)
  # Parse a table row: | val1 | val2 | val3 |
  cells = line.split("|").map(&:strip).reject(&:empty?)
  return nil if cells.size < 3
  
  signal = cells[0].gsub(/\*\*/, "").strip
  detection = cells[1].gsub(/\*\*/, "").strip
  redirect = cells[2].gsub(/\*\*/, "").strip
  
  # Format as "- {Signal}: {Redirect} ({Detection})"
  "- #{signal}: #{redirect} (#{detection})"
end

converted = 0

Dir[PROTOCOLS.join("*.md")].sort.each do |path|
  text = File.read(path)
  lines = text.split("\n")
  new_lines = []
  i = 0
  modified = false
  
  while i < lines.length
    # Look for table start
    if lines[i] =~ /^\|.+\|$/ && is_gotchas_table?(lines, i)
      # Skip the table: header, separator, data rows
      i += 1 # skip header
      i += 1 if i < lines.length && lines[i] =~ /^\|[-:\s]+\|/ # skip separator
      
      # Convert data rows
      while i < lines.length && lines[i] =~ /^\|.+\|$/
        converted_row = convert_table_row(lines[i])
        new_lines << converted_row if converted_row
        i += 1
      end
      modified = true
    else
      new_lines << lines[i]
      i += 1
    end
  end
  
  if modified
    File.write(path, new_lines.join("\n") + "\n")
    converted += 1
    puts "  ✓ #{File.basename(path)}"
  end
end

puts ""
puts "Converted #{converted} files."
