# Ruby Regex — Named Captures

## Match + conditional

```ruby
m = id.to_s.match(PATLIB_ID)
m ? PrefixToType[m[1]] : nil
```

Pattern: match, then branch on presence. Returns `nil` instead of raising.

## Constants as `/\A...\z/`

```ruby
PATLIB_ID = /\A([A-Z]{2,})((?:\.[A-Z][A-Z0-9.\/-]*)+)/
```

All regex constants anchored with `\A` and `\z` — never `^`/`$` (which match line boundaries).

## Frontmatter/backmatter extraction

```ruby
FRONTMATTER_RE = /\A---\s*\n(.*?)\n---\s*\n/m
BACKMATTER_RE  = /---\s*\n(.*?)\n---\s*\z/m
```

- `m` flag for multiline (`.` matches `\n`)
- `\z` for end-of-string (not `\Z` which allows trailing newline)

## YAML safe_load with permitted classes

```ruby
YAML.safe_load(yaml_str, permitted_classes: [Date], symbolize_names: true)
```

`symbolize_names: true` converts string keys to symbol keys (`"id" → :id`).

## Inline match with Regexp

```ruby
/^id[[:space:]]*:[[:space:]]*/.match?(line)
```
