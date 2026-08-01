# Ruby Enumerable — Chunking (chunk, slice_before, slice_after, slice_when, chunk_while)

## chunk

Split by state changes:

```ruby
[1, 2, 4, 9, 10, 12].chunk { |n| n.even? }.to_a
# [[false, [1]], [true, [2, 4]], [false, [9]], [true, [10, 12]]]
```

## slice_before

```ruby
%w[foo bar stuff].slice_before(/b/).to_a     # [["foo"], ["bar", "stuff"]]
```

## slice_after

```ruby
%w[foo bar baz].slice_after(/b/).to_a      # [["foo", "bar"], ["baz"]]
```

## slice_when

```ruby
[1, 2, 3, 5, 6, 9].slice_when { |a, b| b != a + 1 }.to_a
# [[1, 2, 3], [5, 6], [9]]
```

## chunk_while — inverse of slice_when

```ruby
[1, 2, 3, 5, 6, 9].chunk_while { |a, b| b == a + 1 }.to_a
# [[1, 2, 3], [5, 6], [9]]
```
