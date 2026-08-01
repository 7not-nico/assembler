# exports: CheckField, CheckRequired
# ring: 0 (PURE)

CheckField = ->(value, rules) {
  type = rules[:type]
  enum_str = rules[:enum]
  pattern = rules[:pattern]
  min_len = rules[:min_length]
  minimum = rules[:minimum]
  violations = []

  case type
  when "string"
    unless value.is_a?(String) && !value.strip.empty?
      violations << "must be non-empty string"
    end
    if min_len && value.is_a?(String) && value.strip.size < min_len
      violations << "min length #{min_len}"
    end
  when "integer"
    unless value.is_a?(Integer) && (!minimum || value >= minimum)
      violations << "must be integer >= #{minimum || 0}"
    end
  when "array"
    unless value.is_a?(Array)
      violations << "must be array"
    end
  end

  if enum_str
    enum_vals = enum_str.split(",")
    unless enum_vals.include?(value.to_s)
      violations << "must be one of #{enum_vals.join("/")}"
    end
  end

  if pattern && value.is_a?(String)
    unless value.match?(Regexp.new(pattern))
      violations << "pattern mismatch"
    end
  end

  violations
}

CheckRequired = ->(fm, field_name) {
  fm.key?(field_name) ? nil : "required field absent"
}
