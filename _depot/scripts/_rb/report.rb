# exports: Table, List
# ring: 0 (PURE)
# depends-on: ./loader

Table = ->(rows, headers) {
  widths = headers.map.with_index { |h, i| [h.size, *rows.map { |r| r[i].to_s.size }].max }
  head = headers.map.with_index { |h, i| h.ljust(widths[i]) }.join(" | ")
  sep = widths.map { |w| "-" * w }.join("-|-")
  body = rows.map { |r| r.map.with_index { |v, i| v.to_s.ljust(widths[i]) }.join(" | ") }.join("\n")
  "#{head}\n#{sep}\n#{body}"
}

List = ->(items) { items.map { |i| "- #{i}" }.join("\n") }
