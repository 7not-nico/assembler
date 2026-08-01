# Ruby Hash Patterns — Scripts Usage

## fetch / fetch_values

```ruby
meta[:id] || basename                     # fallback to basename
rings.dig(:encyclopedic, 1, :types)       # nested access
```

## Defaults with `||`

```ruby
bm.source ? String(bm.source) : nil
meta[:source].nil? || meta[:source].to_s.strip.empty?
```

## Transform / compact

```ruby
entries.filter_map { |e|
  fm = ParseMetadata.call(t)
  fm ? { file: filenames[i], **fm } : nil
}
```

## Splat merge `**`

```ruby
{ group: group_name, ring: ring_num, **info }
```

Used in `rings.rb` to expand `{ types: %w[...], name: "..." }` into result.

## keys? / values?

```ruby
fm.key?(field_name)   # check field presence
```

## Table construction pattern

```ruby
widths = headers.map.with_index { |h, i|
  [h.size, *rows.map { |r| r[i].to_s.size }].max
}
head = headers.map.with_index { |h, i| h.ljust(widths[i]) }.join(" | ")
```
