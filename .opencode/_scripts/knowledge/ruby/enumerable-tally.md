# Ruby Enumerable — Tally

## tally — count occurrences

```ruby
%w[a b a c a b].tally               # {"a"=>3, "b"=>2, "c"=>1}
```

With block (Ruby 3.1+):

```ruby
%w[cat dog bird].tally(&:length)    # { 3=>2, 4=>1 }
```

Returns Hash with element as key, count as value.
