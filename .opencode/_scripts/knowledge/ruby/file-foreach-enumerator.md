# File — foreach as Lazy Enumerator

## Pattern

`File.foreach(path)` returns an Enumerator, not an array — it yields lines one at a time without loading the whole file into memory.

```ruby
File.foreach('large.log').select { |line| line.include?('ERROR') }.first(10)
```

## Chaining with Enumerable

Since `foreach` returns an Enumerator, any Enumerable method chains:

```ruby
File.foreach('data.csv')
    .map(&:strip)
    .reject(&:empty?)
    .each_with_index
    .filter_map { |line, i| [i, line] if line.start_with?('#') }
```

## Lazy evaluation

```ruby
# Only reads enough lines to find first 5 ERRORs — never loads whole file
File.foreach('server.log')
    .lazy
    .select { |l| l.include?('ERROR') }
    .first(5)
```

## With block

```ruby
File.foreach('data.txt') { |line| puts line if line.include?('TODO') }
```

## Contrast with readlines

```ruby
# Loads entire file into memory
File.readlines('big.csv').each { |line| ... }

# Lazy, one line at a time
File.foreach('big.csv') { |line| ... }
```

## Notes

- `File.foreach` is an alias for `IO.foreach`
- It uses the default record separator (`$/` or `\n`)
- Accepts a second argument for custom separator: `File.foreach(path, sep)`
- Accepts options hash: `File.foreach(path, chomp: true)` to strip trailing newlines
