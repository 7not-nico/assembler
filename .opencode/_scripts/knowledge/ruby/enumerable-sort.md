# Ruby Enumerable — Sorting (sort, sort_by, min, max, minmax)

## sort

```ruby
[3, 1, 2].sort                      # [1, 2, 3]
%w[cat bird Dog].sort               # ["Dog", "bird", "cat"] — ASCIIbetical
```

With block:

```ruby
%w[cat bird Dog].sort { |a, b| a.casecmp(b) }  # ["bird", "cat", "Dog"]
%w[cat bird Dog].sort_by(&:downcase)            # same
```

## sort_by

Schwartzian transform — compute sort key once per element:

```ruby
%w[apple pear banana].sort_by(&:length)         # ["pear", "apple", "banana"]
[{ name: "Zoe" }, { name: "Ana" }].sort_by { |h| h[:name] }  # [{ name: "Ana" }, { name: "Zoe" }]
```

## min / max

```ruby
[3, 1, 2].min                        # 1
[3, 1, 2].max                        # 3
```

With block:

```ruby
%w[cat bird dog].min { |a, b| a.length <=> b.length }  # "cat"
```

## minmax — returns [min, max]

```ruby
[3, 1, 2].minmax                     # [1, 3]
```

## min_by / max_by / minmax_by

```ruby
%w[apple pear banana].min_by(&:length)   # "pear"
%w[apple pear banana].max_by(&:length)   # "banana"
%w[apple pear banana].minmax_by(&:length) # ["pear", "banana"]
```
