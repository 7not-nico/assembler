#!/usr/bin/env ruby
# ring: 0 (PURE) — validates entities against schema definitions
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/validate, _rb/fields

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/validate"
require_relative "_rb/fields"

violations = []
all_fields = LoadAllFields.call

all_fields.each do |type_name, rows|
  has_required = rows.any? { |r| r[1] == 1 }

  Dir[EntityGlob.call(type_name)].each do |path|
    text = File.read(path)
    basename = File.basename(path, ".md")
    fm = ParseMetadata.call(text)

    unless fm
      if has_required
        violations << [basename, type_name, "metadata", "-", "no frontmatter or backmatter"]
      end
      next
    end

    rows.each do |field_name, required, field_type, enum_str, pattern, min_len, minimum|
      fname = field_name.to_sym
      rules = { type: field_type, enum: enum_str, pattern: pattern, min_length: min_len, minimum: minimum }

      if required == 1
        missing = CheckRequired.call(fm, fname)
        if missing
          violations << [fm[:id] || basename, type_name, field_name, "missing", missing]
          next
        end
      end

      next unless fm.key?(fname)

      errors = CheckField.call(fm[fname], rules)
      errors.each do |err|
        violations << [fm[:id] || basename, type_name, field_name, fm[fname].inspect, err]
      end
    end
  end
end

if violations.empty?
  puts "ok — all entities comply with schema definitions"
else
  puts "schema violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Field Value Problem])
end
