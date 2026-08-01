# Ruby Enumerable Chain — Scripts Pattern

Data flows through method chains. No `for`, no mutable accumulators.

## map / filter_map / flat_map

```ruby
files.map { |f| { type: t, path: Pathname.new(f), name: File.basename(f, ".md") } }

Dirs.select { |d| Dir.glob(File.join(d, "**", "*.md")).any? }

entries.filter_map { |e| e[:id] if condition }
```

## group_by + detect cycle

```ruby
by_id = entries.group_by { |e| e[:id] }
dupes = by_id.select { |_, g| g.size > 1 }
```

## each_with_index + filter_map

```ruby
refs.each_with_index.filter_map { |ref, i|
  ref.is_a?(Hash) ? nil : [basename, "reference[#{i}]", "not a hash"]
}
```

## flat_map

```ruby
RingGroups.flat_map { |g, rings| rings.map { |r, info| { group: g, ring: r, **info } } }
```

## reduce (pipeline)

```ruby
steps.reduce(->(x) { x }, &:>>)
```

## Chain conventions

| Pattern | Use | Avoid |
|---------|-----|-------|
| `map` → `filter_map` | Transform + compact | `select` → `map` |
| `flat_map` | One-to-many | `map` + `flatten(1)` |
| `group_by` → `select` | Find duplicates | Manual hash building |
| `reduce(:>>)` | Dynamic pipeline | Manual loop |
