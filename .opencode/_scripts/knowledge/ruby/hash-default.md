# Ruby Hash — Default Values

## Default value

```ruby
h = Hash.new(0)
h[:x]       # 0  — default returned for missing keys
h.default  # 0
h.default = -1
h[:x]       # -1
```

**Caution**: mutable defaults are shared — don't mutate:

```ruby
h = Hash.new([])
h[:a] << 1          # mutates the default object!
h[:b]               # [1] — same default object
```

## Default proc

Safer for mutable defaults — creates a new object per missing key:

```ruby
h = Hash.new { |hash, key| hash[key] = [] }
h[:a] << 1          # creates []
h[:a]               # [1]
h[:b]               # []  — fresh list
```

Default proc receives `(hash, key)`. Setting default proc clears default value and vice versa.
