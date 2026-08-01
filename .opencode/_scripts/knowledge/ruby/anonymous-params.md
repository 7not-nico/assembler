# Ruby Anonymous Block Parameters

Ruby 3.4+ provides two forms of implicit block parameters.

## `it` — single implicit parameter

```ruby
%w[test me please].each { puts it.upcase }
(1..5).map { it**2 }  # [1, 4, 9, 16, 25]
```

Blocks using `it` are considered to have one parameter. `it` is a soft keyword — usable as local var/method name outside blocks.

## `_1`..`_9` — numbered parameters

For multi-parameter blocks:

```ruby
{a: 100, b: 200}.map { "#{_1} = #{_2}" }
# ["a = 100", "b = 200"]

[10, 20, 30].zip([40, 50, 60], [70, 80, 90]).map { _1 + _2 + _3 }
# [120, 150, 180]
```

## Constraints

- Can't mix `it` with explicit params
- Can't mix `it` with numbered params  
- Can't mix numbered params with explicit params
- Can't nest blocks that both use numbered params
- `_1`..`_9` reserved — can't use as local variable names
