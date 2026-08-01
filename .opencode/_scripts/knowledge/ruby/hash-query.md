# Ruby Hash — Querying

## Size

```ruby
{}.empty?          # true
{a: 1}.empty?      # false
{a: 1, b: 2}.size   # 2
{a: 1}.length       # 1
```

## Membership

```ruby
h = {a: 1, b: 2}
h.include?(:a)     # true — key check (aliases: has_key?, key?, member?)
h.key?(:a)         # true
h.has_key?(:a)     # true

h.value?(1)        # true — value check (alias: has_value?)
h.has_value?(1)    # true
```

## Predicates

```ruby
h.any? { |k, v| v > 1 }     # true
```

## Default

```ruby
h.default         # nil or set value
h.default_proc    # nil or set proc
```

## Identity

```ruby
h.compare_by_identity?   # true if using object identity
h.hash                   # integer hash code
```
