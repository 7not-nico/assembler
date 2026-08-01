# Ruby Function Composition

`Proc#>>` and `Proc#<<` compose procs left-to-right and right-to-left (Ruby 2.6+).

```ruby
f = proc {|x| x * x }
g = proc {|x| x + x }

(f >> g).call(2)  # 8   — f then g:  (2*2) + (2*2) = 8
(f << g).call(2)  # 16  — g then f: (2+2) * (2+2) = 16
```

## Pipeline pattern

Compose with any object responding to `.call`:

```ruby
class Parser
  def self.call(text)
    # parsing logic
  end
end

pipeline = File.method(:read) >> Parser >> proc { |data| puts data.size }
pipeline.call('data.json')
```

## Works with Method too

```ruby
double = proc { |x| x * 2 }
add_one = ->(x) { x + 1 }

double >> add_one  # compose proc + lambda
```
