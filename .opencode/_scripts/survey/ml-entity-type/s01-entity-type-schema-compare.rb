#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — compare all PROT.*.IDENTITY.SCHEMA protocol schema tables
# survey: ml-entity-type — inform schema design for new ML entity type

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

prot_dir = ENTITIES.join("protocols")
prot_files = Dir[prot_dir.join("PROT.*.IDENTITY.SCHEMA.md")].sort

rows = []
prot_files.each do |f|
  text = File.read(f)
  bak = ParseFrontmatter.call(text)
  next unless bak
  id = bak[:id] || File.basename(f, ".md")
  # Extract schema table — lines between "### Schema" and next "###" or "##" or end
  schema_lines = []
  inside = false
  text.each_line do |line|
    if line =~ /###\s+Schema/
      inside = true
      next
    end
    if inside
      break if line =~ /^#/
      schema_lines << line.chomp
    end
  end
  # Filter table rows
  table_rows = schema_lines.select { |l| l.start_with?("|") }
  next if table_rows.empty?
  # Parse header + body
  # Header: | Field | Required | Format |
  # Data rows: | `id` | Yes | `ML.{NAME}` ... |
  data = table_rows[2..] || []  # skip header + separator
  fields = data.filter_map do |r|
    cols = r.split("|").map(&:strip).reject(&:empty?)
    next if cols.size < 3
    { field: cols[0], required: cols[1], format: cols[2] }
  end
  fields.each do |fld|
    rows << [id, fld[:field], fld[:required], fld[:format]]
  end
end

puts "=== PROT.*.IDENTITY.SCHEMA — Schema Field Comparison ==="
puts ""
if rows.empty?
  puts "No schema tables found in protocol files."
else
  puts Table.call(rows, %w[Protocol Field Required Format])
end
puts ""
puts "Total protocol files scanned: #{prot_files.size}"
