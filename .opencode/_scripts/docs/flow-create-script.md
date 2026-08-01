# Creating a New Ring Script

## Naming

```
r{code-ring}-{descriptive-name}.rb
```

- `r` = ring.
- `{code-ring}` = SPEC.CODE.RING.TOPOLOGY ring number (0–6). r0 = PURE (innermost), r6 = DB-WRITE (outermost).
- `{descriptive-name}` = hyphen-separated, no "ring" in name (r is sufficient).

Valid: `r2-source-validate.rb`, `r1-group-count.rb`
Invalid: `r9-anything.rb` (r9 is not a code ring)

## Header

Every script starts with:

```ruby
#!/usr/bin/env ruby
# ring: N (NAME) — short descriptor
# depends-on: _rb/paths, _rb/frontmatter, _rb/report[, _rb/rings]
```

- `# ring:` — required. N must match filename prefix. NAME from SPEC.CODE.RING.TOPOLOGY.
- `# depends-on:` — required. List all `_rb/` modules used.

## Template

```ruby
#!/usr/bin/env ruby
# ring: 1 (DB-READ) — validates X
# depends-on: _rb/paths, _rb/frontmatter, _rb/report

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

# parse all entities
files = EntityTypes.flat_map { |t|
  Dir[EntityGlob.call(t)].map { |p| { type: t, path: Pathname.new(p), name: File.basename(p, ".md") } }
}
texts = files.map { |f| f[:path].read }
entries = ParseAll.call(texts, files.map { |f| f[:name] })
entries.each { |e| e[:type] = files.find { |f| f[:name] == e[:file] }[:type] }

# filter to target type
target = entries.select { |e| e[:type] == "..." }

# validate
violations = []
target.each do |e|
  # check condition
end

if violations.empty?
  puts "ok — #{target.size} entities, 0 violations"
else
  puts "violations (#{violations.size}):"
  puts Table.call(violations, %w[Header Column Names])
end
```

## Reports

After running, write output to:

| If result | Path |
|-----------|------|
| No violations | `report/conclusions/{name}-{timestamp}.txt` |
| Has violations | `report/errors/{name}-{timestamp}.txt` |
| Process description | `report/walkthroughs/{topic}-{timestamp}.md` |
