# Ruby Array

`Array` — an ordered, integer-indexed collection of any objects. Mixes in `Enumerable`.

## Creation

```ruby
[]                     # empty
[1, 'a', :b]           # mixed types
Array.new              # []
Array.new(3)           # [nil, nil, nil]
Array.new(3, true)     # [true, true, true] — same object ref
Array.new(3) { |i| i } # [0, 1, 2] — block per element
Array(1..5)            # [1, 2, 3, 4, 5]
%w[a b c]              # ["a", "b", "c"] — string array
%i[a b c]              # [:a, :b, :c] — symbol array
```

## Indexing

```ruby
arr = [10, 20, 30, 40, 50]
arr[0]    # 10
arr[-1]   # 50  (negative = from end)
arr[0..2] # [10, 20, 30]  (range)
arr[0, 3] # [10, 20, 30]  (start, length)
```

## Official Docs

<https://docs.ruby-lang.org/en/3.4/Array.html>
