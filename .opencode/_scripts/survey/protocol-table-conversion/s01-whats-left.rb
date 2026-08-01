#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — survey remaining markdown tables in protocols
# survey: protocol-table-conversion
# non-write

require_relative "../../_rb/loader"
require_relative "../../_rb/report"

ROOT = Pathname.new(__dir__).join("..", "..", "..").realpath
PROTOCOLS = ROOT.join(".opencode", "entities", "protocols")

results = []

Dir[PROTOCOLS.join("*.md")].sort.each do |path|
  text = File.read(path)
  lines = text.split("\n")
  basename = File.basename(path)

  # Find table lines (start with |)
  tables = []
  current_table = nil

  lines.each_with_index do |line, idx|
    if line =~ /^\|.+\|/
      current_table ||= { start_line: idx + 1, sample_headers: "", rows: 0 }
      if current_table[:rows] == 0
        current_table[:sample_headers] = line.strip[0..80]
      end
      current_table[:rows] += 1
    else
      if current_table && current_table[:rows] >= 3
        tables << current_table.dup
      end
      current_table = nil
    end
  end
  if current_table && current_table[:rows] >= 3
    tables << current_table
  end

  tables.each do |t|
    results << [basename, t[:start_line].to_s, t[:rows].to_s, t[:sample_headers]]
  end
end

puts "=== Protocol Tables Remaining ==="
puts ""

if results.empty?
  puts "ok — 0 tables remaining in protocols"
else
  # Summarize by file
  file_counts = results.group_by { |r| r[0] }
  puts "Files with tables: #{file_counts.size}"
  puts "Total tables: #{results.size}"
  puts ""

  file_counts.sort.each do |file, tbls|
    puts "  #{file} (#{tbls.size} tables)"
    tbls.each do |t|
      puts "    L#{t[1]}  [#{t[2]} rows]  #{t[3][0..60]}"
    end
    puts ""
  end

  puts "=== Table types ==="
  type_counts = results.group_by { |r| r[3] }.map { |k, v| [k[0..60], v.size] }.sort_by { |_, v| -v }
  type_counts.each do |header, count|
    puts "  #{count}x  #{header}"
  end
end
