# Ruby Guard Clause Pattern

Early return for nil/invalid input. Used in every `_rb/` lambda.

## Basic guard

```ruby
NormalizeTags = ->(fm) {
  return fm unless fm
  fm[:tags] ||= []
  fm
}
```

Returns input unchanged when nil — pure, no mutation.

## nil coalescing with `||`

```ruby
m ? PrefixToType[m[1]] : nil
```

Pattern: match → branch. Nil is the canonical "not found" value.

## Safe navigation combined

```ruby
fm[:id] || basename
```

Fallback to basename when id field absent.

## Multiple conditions

```ruby
return Qfalse unless rb_obj_is_kind_of(obj, rb_cRange)
```

Can chain: `unless x` → `if x.nil?` → `if x.empty?`.

## Empty check

```ruby
return nil if v.nil? || v.strip.empty?
return nil if v == "NULL"
```

Two-step guard: first structural, then semantic.
