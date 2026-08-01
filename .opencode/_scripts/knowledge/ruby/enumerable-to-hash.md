# Ruby Enumerable — to_h

## to_h — convert to hash

```ruby
%w[cat dog].map { |w| [w, w.length] }.to_h  # {"cat"=>3, "dog"=>3}
```

With block:

```ruby
(1..3).to_h { |n| [n, n ** 2] }          # { 1=>1, 2=>4, 3=>9 }
```

Duplicate keys — last wins.
