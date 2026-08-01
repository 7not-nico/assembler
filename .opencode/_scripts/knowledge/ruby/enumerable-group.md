# Ruby Enumerable — Grouping (group_by)

## group_by

Returns hash mapping each computed key to array of elements:

```ruby
(1..6).group_by(&:even?)           # { false=>[1, 3, 5], true=>[2, 4, 6] }
%w[cat dog cow bird].group_by(&:length)  # { 3=>["cat", "dog", "cow"], 4=>["bird"] }
```

With block accepting element:

```ruby
(1..6).group_by { |n| n % 3 }     # { 0=>[3, 6], 1=>[1, 4], 2=>[2, 5] }
```
