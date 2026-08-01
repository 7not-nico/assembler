# Ruby Hash

`Hash` maps each unique key to a specific value. Includes `Enumerable`.

## Creation

```ruby
{}                          # empty hash
{foo: 0, bar: 1}            # JSON-style (Symbol keys)
{:foo => 0, 'bar' => 1}     # hash-rocket (any key type)
{x:, y:}                    # value from context: {x: x, y: y}
Hash.new                    # {}
Hash.new(0)                 # default value 0
Hash.new { |h, k| h[k] = [] }  # default proc
Hash[:a, 1, :b, 2]         # => {:a=>1, :b=>2}
Hash[{a: 1}]                # => {:a=>1} — conversion
```

## Key facts

- Keys must implement `hash` and `eql?` (unless `compare_by_identity`)
- String keys are auto-duplicated and frozen for safety
- Modifying a key while it's in use damages the index — call `rehash` to repair
- Insertion order is preserved

## Official Docs

<https://docs.ruby-lang.org/en/3.4/Hash.html>
