#!/usr/bin/env ruby
# ring: 1 (DB-READ) — term backmatter structural audit

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/validate"
require_relative "_rb/violation"
require_relative "_rb/bench"
require_relative "_rb/fields"
require_relative "_rb/audit"

check_refs = ->(data, basename, violations) {
  if data[:reference]
    data[:reference].each_with_index do |ref, i|
      unless ref.is_a?(Hash) && ref[:title] && ref[:url]
        violations << [data[:id] || basename, "terms", "reference[#{i}]", ref.inspect, "must be {title:, url:}"]
      end
    end
  end
}

AuditEntityType.call("terms", ->(text) { ParseBackmatter.call(text) }, check_refs)
