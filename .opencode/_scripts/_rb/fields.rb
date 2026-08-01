# exports: LoadFields, LoadAllFields
# ring: 0 (PURE)

SQL_DIR = File.join(__dir__, "..", "schema")

def _find_matching_paren(text, start)
  quote = nil
  paren = 1
  i = start + 1
  while i < text.length && paren > 0
    c = text[i]
    if quote
      quote = nil if c == quote
    elsif c == "'" || c == '"'
      quote = c
    elsif c == '('
      paren += 1
    elsif c == ')'
      paren -= 1
    end
    i += 1
  end
  paren == 0 ? i - 1 : nil
end

ParseValues = ->(text) {
  rows = []
  return rows if text.nil? || text.strip.empty?
  while (start = text.index("("))
    end_idx = _find_matching_paren(text, start)
    break unless end_idx
    content = text[(start + 1)...end_idx]
    vals = []
    current = ""
    quote = nil
    content.each_char do |c|
      if quote
        current << c
        quote = nil if c == quote
      elsif c == "'" || c == '"'
        current << c
        quote = c
      elsif c == ','
        vals << current.strip
        current = ""
      else
        current << c
      end
    end
    vals << current.strip
    rows << vals unless vals.empty?
    text = text[(end_idx + 1)..]
  end
  rows
}

CleanVal = ->(v) {
  return nil if v.nil? || v.strip.empty?
  v = v.strip
  return nil if v == "NULL"
  v = v[1..-2] if v.start_with?("'") && v.end_with?("'")
  v
}

# Returns array of [name, required, field_type, enum, pattern, min_length, minimum]
# matching QueryFields output format
LoadFields = ->(type_name) {
  Dir.glob(File.join(SQL_DIR, "[0-9]*.sql")).sort.each do |path|
    text = File.read(path)
    next unless text.include?("'#{type_name}'")
    m = text.match(/INSERT OR REPLACE INTO fields.*?VALUES\s*\n\s*(.*?);/m)
    next unless m && m[1] && !m[1].strip.empty?
    all = ParseValues.call(m[1])
    return all.select { |row| CleanVal.call(row[0]) == type_name }.map { |vals|
      [CleanVal.call(vals[1]), CleanVal.call(vals[2]).to_i, CleanVal.call(vals[3]),
       CleanVal.call(vals[4]), CleanVal.call(vals[5]), CleanVal.call(vals[6])&.to_i,
       CleanVal.call(vals[7])&.to_i]
    }
  end
  []
}

LoadAllFields = -> {
  result = {}
  Dir.glob(File.join(SQL_DIR, "[0-9]*.sql")).sort.each do |path|
    text = File.read(path)
    type_m = text.match(/INSERT OR REPLACE INTO entity_types.*?'([^']+)'/)
    next unless type_m
    type_name = type_m[1]
    ftext = text.match(/INSERT OR REPLACE INTO fields.*?VALUES\s*\n\s*(.*?);/m)
    next unless ftext && ftext[1] && !ftext[1].strip.empty?
    all = ParseValues.call(ftext[1])
    fields = all.select { |row| CleanVal.call(row[0]) == type_name }.map { |vals|
      [CleanVal.call(vals[1]), CleanVal.call(vals[2]).to_i, CleanVal.call(vals[3]),
       CleanVal.call(vals[4]), CleanVal.call(vals[5]), CleanVal.call(vals[6])&.to_i,
       CleanVal.call(vals[7])&.to_i]
    }
    result[type_name] = fields unless fields.empty?
  end
  result
}
