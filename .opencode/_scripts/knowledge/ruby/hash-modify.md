# Ruby Hash — Modifying

## Assign

```ruby
h = {}
h[:a] = 1        # {a: 1}
h.store(:b, 2)   # {a: 1, b: 2}
```

## Merge / Update

```ruby
h = {a: 1, b: 2}
h.merge({b: 3, c: 4})      # {a: 1, b: 3, c: 4}  — new hash
h.merge!({b: 3})           # {a: 1, b: 3}         — mutates
h.update({b: 3})           # alias for merge!

# merge with block handles duplicates
h.merge({b: 3}) { |key, old, new| old + new }  # {a: 1, b: 5}
```

## Replace

```ruby
h.replace({x: 9})   # {x: 9}  — replaces all content
```

## Delete

```ruby
h = {a: 1, b: 2, c: 3}
h.delete(:a)        # 1         — returns value
h.delete(:x)        # nil       — not found
h.delete(:x) { |k| "no #{k}" }  # "no x"  — block runs on miss
```

## Conditional deletion

```ruby
h.delete_if { |k, v| v < 3 }    # mutates
h.keep_if  { |k, v| v >= 3 }    # mutates (inverse of delete_if)
h.reject!  { |k, v| v < 3 }     # returns nil if unchanged
h.select!  { |k, v| v >= 3 }    # returns nil if unchanged
```

## Clear / Shift / Compact

```ruby
h.clear            # {}
h.shift            # removes first entry, returns [key, value] or nil
h.compact!         # removes all nil-valued entries (mutates)
```
