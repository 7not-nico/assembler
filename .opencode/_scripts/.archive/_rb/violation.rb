# exports: ReportViolations, run_audit
# ring: 0 (PURE)

ReportViolations = ->(violations, entity_type, label = "audit") {
  if violations.empty?
    "ok — #{entity_type} #{label}: 0 violations"
  else
    "#{entity_type} #{label} violations (#{violations.size}):\n" +
    Table.call(violations, %w[ID Type Field Value Problem])
  end
}

run_audit = ->(entries, field_rules, &block) {
  violations = []
  entries.each do |entry|
    block.call(entry, field_rules, violations)
  end
  violations
}
