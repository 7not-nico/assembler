# exports: AuditEntityType
# ring: 0 (PURE)
# depends-on: _rb/paths, _rb/frontmatter, _rb/report, _rb/validate, _rb/violation, _rb/bench, _rb/fields

AuditEntityType = ->(type_name, parse_fn, custom_check = nil) {
  start = Time.now
  violations = []
  rows = LoadFields.call(type_name)

  begin
    Dir[EntityGlob.call(type_name)].each do |path|
      text = File.read(path)
      basename = File.basename(path, ".md")
      data = parse_fn.call(text)

      unless data
        violations << [basename, type_name, "metadata", "-", "no metadata found"]
        next
      end

      rows.each do |field_name, required, field_type, enum_str, pattern, min_len, minimum|
        fname = field_name.to_sym
        rules = { type: field_type, enum: enum_str, pattern: pattern, min_length: min_len, minimum: minimum }

        if required == 1
          missing = CheckRequired.call(data, fname)
          if missing
            violations << [data[:id] || basename, type_name, field_name, "missing", missing]
            next
          end
        end

        next unless data.key?(fname)

        errors = CheckField.call(data[fname], rules)
        errors.each do |err|
          violations << [data[:id] || basename, type_name, field_name, data[fname].inspect, err]
        end
      end

      if custom_check
        custom_check.call(data, basename, violations)
      end
    end
  rescue => e
    violations << ["SYSTEM", type_name, "exception", e.message, e.class.to_s]
  ensure
    puts ReportViolations.call(violations, "#{Dir[EntityGlob.call(type_name)].size} #{type_name}", "audit")
    elapsed = Time.now - start
    $stderr.puts "  [#{FormatDuration.call(elapsed)}] #{type_name} audit"
  end
}
