# Ruby Regexp — Scan & Split (scan, split, partition)

## scan — extract all matches

Returns array of matches:

```ruby
"hello world".scan(/l/)              # ["l", "l", "l"]
"abc123def456".scan(/\d+/)           # ["123", "456"]
```

With captures — returns array of arrays:

```ruby
"cat,sat".scan(/(\w+),(\w+)/)        # [["cat", "sat"]]
"a:1 b:2".scan(/(\w+):(\d+)/)        # [["a", "1"], ["b", "2"]]
```

With block:

```ruby
result = []
"abc123".scan(/\d/) { |d| result << d.to_i }
result                                 # [1, 2, 3]
```

## split — split string by regex

```ruby
"a,b,c".split(/,/)                   # ["a", "b", "c"]
"a,b,c".split(/,/, 2)                # ["a", "b,c"] — limit
"a, b,  c".split(/, */)              # ["a", "b", "c"]
"a-b_c".split(/[-_]/)                # ["a", "b", "c"]
```

With capture — includes delimiter:

```ruby
"a,b,c".split(/(,)/)                 # ["a", ",", "b", ",", "c"]
```

## partition / rpartition — split on first/last match

```ruby
"hello.world.ruby".partition(/\./)   # ["hello", ".", "world.ruby"]
"hello.world.ruby".rpartition(/\./)  # ["hello.world", ".", "ruby"]
```
